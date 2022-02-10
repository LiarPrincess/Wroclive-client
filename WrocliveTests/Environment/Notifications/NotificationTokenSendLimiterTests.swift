// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

private let interval = NotificationTokenSendLimiter.sendInterval
private let dateInitial = Date(timeIntervalSince1970: 0.0)
private let dateWithinInterval = Date(timeInterval: interval - 1.0, since: dateInitial)
private let dateAfterInterval = Date(timeInterval: interval + 1.0, since: dateInitial)

private var dateMock = dateInitial

private func getDateMock() -> Date {
  return dateMock
}

final class NotificationTokenSendLimiterTests: XCTestCase {

  // MARK: - Should send

  func test_shouldSend_if_tokenWasNotStored() {
    let store = NotificationTokenStoreMock()
    let limiter = NotificationTokenSendLimiter(store: store, getDate: getDateMock)

    XCTAssertNil(store.storedNotificationToken) // Not stored

    dateMock = dateInitial
    let result = limiter.shouldSend(token: "TOKEN_VALUE")

    XCTAssertTrue(result)
    XCTAssertEqual(store.getNotificationTokenCallCount, 1)
    XCTAssertEqual(store.setNotificationTokenCallCount, 0)
  }

  func test_shouldSend_when_tokenChanged() {
    let store = NotificationTokenStoreMock()
    let limiter = NotificationTokenSendLimiter(store: store, getDate: getDateMock)

    store.storedNotificationToken = StoredNotificationToken(
      date: dateInitial,
      value: "OLD_TOKEN_VALUE"
    )

    dateMock = dateWithinInterval
    let result = limiter.shouldSend(token: "TOKEN_VALUE")

    XCTAssertTrue(result)
    XCTAssertEqual(store.getNotificationTokenCallCount, 1)
    XCTAssertEqual(store.setNotificationTokenCallCount, 0)
  }

  func test_shouldSend_when_storedToken_isFromFuture() {
    let store = NotificationTokenStoreMock()
    let limiter = NotificationTokenSendLimiter(store: store, getDate: getDateMock)

    store.storedNotificationToken = StoredNotificationToken(
      date: dateWithinInterval,
      value: "TOKEN_VALUE"
    )

    dateMock = dateInitial
    let result = limiter.shouldSend(token: "TOKEN_VALUE")

    XCTAssertTrue(result)
    XCTAssertEqual(store.getNotificationTokenCallCount, 1)
    XCTAssertEqual(store.setNotificationTokenCallCount, 0)
  }

  func test_shouldSend_after_sendInterval() {
    let store = NotificationTokenStoreMock()
    let limiter = NotificationTokenSendLimiter(store: store, getDate: getDateMock)

    store.storedNotificationToken = StoredNotificationToken(
      date: dateInitial,
      value: "TOKEN_VALUE"
    )

    dateMock = dateAfterInterval
    let result = limiter.shouldSend(token: "TOKEN_VALUE")

    XCTAssertTrue(result)
    XCTAssertEqual(store.getNotificationTokenCallCount, 1)
    XCTAssertEqual(store.setNotificationTokenCallCount, 0)
  }

  func test_shouldNotSend_within_sendInterval() {
    let store = NotificationTokenStoreMock()
    let limiter = NotificationTokenSendLimiter(store: store, getDate: getDateMock)

    store.storedNotificationToken = StoredNotificationToken(
      date: dateInitial,
      value: "TOKEN_VALUE"
    )

    dateMock = dateWithinInterval
    let result = limiter.shouldSend(token: "TOKEN_VALUE")

    XCTAssertFalse(result)
    XCTAssertEqual(store.getNotificationTokenCallCount, 1)
    XCTAssertEqual(store.setNotificationTokenCallCount, 0)
  }

  // MARK: - Register send

  func test_registerSend_storesToken() {
    let store = NotificationTokenStoreMock()
    let limiter = NotificationTokenSendLimiter(store: store, getDate: getDateMock)

    XCTAssertNil(store.storedNotificationToken)

    dateMock = dateInitial
    let token = "TOKEN_VALUE"
    limiter.registerSend(token: token)

    let expected = StoredNotificationToken(date: dateInitial, value: token)
    XCTAssertEqual(store.storedNotificationToken, expected)
    XCTAssertEqual(store.setNotificationTokenCallCount, 1)
    XCTAssertEqual(store.getNotificationTokenCallCount, 0)
  }
}
