// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

// swiftlint:disable force_unwrapping

private let interval = RemoteNotificationTokenSendLimiter.sendInterval
private let dateInitial = Date(timeIntervalSince1970: 0.0)
private let dateWithinInterval = Date(timeInterval: interval - 1.0, since: dateInitial)
private let dateAfterInterval = Date(timeInterval: interval + 1.0, since: dateInitial)

private var dateMock = dateInitial

private let deviceId = UUID(uuidString: "11111111-2222-3333-4444-555555555555")!
private let deviceIdOld = UUID(uuidString: "11111111-AAAA-3333-BBBB-555555555555")!

private func getDateMock() -> Date {
  return dateMock
}

final class RemoteNotificationTokenSendLimiterTests: XCTestCase {

  // MARK: - Should send

  func test_shouldSend_if_tokenWasNotStored() {
    let store = RemoteNotificationTokenStoreMock()
    let limiter = RemoteNotificationTokenSendLimiter(store: store, getDate: getDateMock)

    store.storedToken = nil // Not stored

    dateMock = dateInitial
    let result = limiter.shouldSend(deviceId: deviceId, token: "TOKEN_VALUE")

    XCTAssertTrue(result)
    XCTAssertEqual(store.getNotificationTokenCallCount, 1)
    XCTAssertEqual(store.setNotificationTokenCallCount, 0)
  }

  func test_shouldSend_when_tokenChanged() {
    let store = RemoteNotificationTokenStoreMock()
    let limiter = RemoteNotificationTokenSendLimiter(store: store, getDate: getDateMock)

    store.storedToken = StoredRemoteNotificationToken(
      date: dateInitial,
      deviceId: deviceId,
      token: "OLD_TOKEN_VALUE"
    )

    dateMock = dateWithinInterval
    let result = limiter.shouldSend(deviceId: deviceId, token: "TOKEN_VALUE")

    XCTAssertTrue(result)
    XCTAssertEqual(store.getNotificationTokenCallCount, 1)
    XCTAssertEqual(store.setNotificationTokenCallCount, 0)
  }

  func test_shouldSend_when_deviceIdChanged() {
    let store = RemoteNotificationTokenStoreMock()
    let limiter = RemoteNotificationTokenSendLimiter(store: store, getDate: getDateMock)

    store.storedToken = StoredRemoteNotificationToken(
      date: dateInitial,
      deviceId: deviceIdOld,
      token: "TOKEN_VALUE"
    )

    dateMock = dateWithinInterval
    let result = limiter.shouldSend(deviceId: deviceId, token: "TOKEN_VALUE")

    XCTAssertTrue(result)
    XCTAssertEqual(store.getNotificationTokenCallCount, 1)
    XCTAssertEqual(store.setNotificationTokenCallCount, 0)
  }

  func test_shouldSend_when_storedToken_isFromTheFuture() {
    let store = RemoteNotificationTokenStoreMock()
    let limiter = RemoteNotificationTokenSendLimiter(store: store, getDate: getDateMock)

    store.storedToken = StoredRemoteNotificationToken(
      date: dateWithinInterval, // dateInitial + interval - 1
      deviceId: deviceId,
      token: "TOKEN_VALUE"
    )

    dateMock = dateInitial
    let result = limiter.shouldSend(deviceId: deviceId, token: "TOKEN_VALUE")

    XCTAssertTrue(result)
    XCTAssertEqual(store.getNotificationTokenCallCount, 1)
    XCTAssertEqual(store.setNotificationTokenCallCount, 0)
  }

  func test_shouldSend_after_sendInterval() {
    let store = RemoteNotificationTokenStoreMock()
    let limiter = RemoteNotificationTokenSendLimiter(store: store, getDate: getDateMock)

    store.storedToken = StoredRemoteNotificationToken(
      date: dateInitial,
      deviceId: deviceId,
      token: "TOKEN_VALUE"
    )

    dateMock = dateAfterInterval
    let result = limiter.shouldSend(deviceId: deviceId, token: "TOKEN_VALUE")

    XCTAssertTrue(result)
    XCTAssertEqual(store.getNotificationTokenCallCount, 1)
    XCTAssertEqual(store.setNotificationTokenCallCount, 0)
  }

  func test_shouldNotSend_within_sendInterval() {
    let store = RemoteNotificationTokenStoreMock()
    let limiter = RemoteNotificationTokenSendLimiter(store: store, getDate: getDateMock)

    store.storedToken = StoredRemoteNotificationToken(
      date: dateInitial,
      deviceId: deviceId,
      token: "TOKEN_VALUE"
    )

    dateMock = dateWithinInterval
    let result = limiter.shouldSend(deviceId: deviceId, token: "TOKEN_VALUE")

    XCTAssertFalse(result)
    XCTAssertEqual(store.getNotificationTokenCallCount, 1)
    XCTAssertEqual(store.setNotificationTokenCallCount, 0)
  }

  // MARK: - Register send

  func test_registerSend_storesToken() {
    let store = RemoteNotificationTokenStoreMock()
    let limiter = RemoteNotificationTokenSendLimiter(store: store, getDate: getDateMock)

    XCTAssertNil(store.storedToken)

    dateMock = dateInitial
    let token = "TOKEN_VALUE"
    limiter.registerSend(deviceId: deviceId, token: token)

    let expected = StoredRemoteNotificationToken(
      date: dateInitial,
      deviceId: deviceId,
      token: token
    )

    XCTAssertEqual(store.storedToken, expected)
    XCTAssertEqual(store.setNotificationTokenCallCount, 1)
    XCTAssertEqual(store.getNotificationTokenCallCount, 0)
  }
}
