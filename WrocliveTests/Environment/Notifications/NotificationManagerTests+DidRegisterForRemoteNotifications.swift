// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import PromiseKit
import WrocliveTestsShared
@testable import WrocliveFramework

// swiftlint:disable:next force_unwrapping
private let token = "TOKEN_VALUE".data(using: .utf8)!
private let tokenToSend = "544f4b454e5f56414c5545"

private let deviceId = UUID(uuidString: "11111111-2222-3333-4444-555555555555")

private typealias RegisterError = NotificationManager.RegisterForRemoteNotificationsError

private func XCTAssertRejection(_ result: PromiseKit.Result<Void>,
                                _ expectedError: RegisterError,
                                file: StaticString = #file,
                                line: UInt = #line) {
  switch result {
  case .fulfilled():
    XCTFail("Fulfilled", file: file, line: line)

  case .rejected(let error):
    if let registerError = error as? RegisterError {
      XCTAssertEqual(registerError, expectedError, file: file, line: line)
      return
    }

    XCTFail("Rejected for other reason", file: file, line: line)
  }
}

extension NotificationManagerTests {

  func test_didRegisterForRemoteNotifications_without_deviceId_doesNothing() {
    self.device.identifierForVendor = nil
    self.tokenSendLimiter.shouldSendResult = true

    let expectation = XCTestExpectation(description: "result")
    _ = self.manager.didRegisterForRemoteNotifications(deviceToken: token).tap { result in
      XCTAssertRejection(result, .deviceIdentifierNotPresent)
      expectation.fulfill()
    }

    self.wait(for: expectation)
    XCTAssertEqual(self.tokenSendLimiter.shouldSendCallCount, 0)
    XCTAssertEqual(self.tokenSendLimiter.registerSendCallCount, 0)
    XCTAssertEqual(self.api.sendNotificationTokenCallCount, 0)
  }

  func test_didRegisterForRemoteNotifications_limitedBy_limiter_doesNothing() {
    self.device.identifierForVendor = deviceId
    self.tokenSendLimiter.shouldSendResult = false

    let expectation = XCTestExpectation(description: "result")
    _ = self.manager.didRegisterForRemoteNotifications(deviceToken: token).tap { result in
      XCTAssertRejection(result, .sendRateLimitExhausted)
      expectation.fulfill()
    }

    self.wait(for: expectation)
    XCTAssertEqual(self.tokenSendLimiter.shouldSendCallCount, 1)
    XCTAssertEqual(self.tokenSendLimiter.registerSendCallCount, 0)
    XCTAssertEqual(self.api.sendNotificationTokenCallCount, 0)
  }

  func test_didRegisterForRemoteNotifications_sendsValuesViaApi() {
    self.device.identifierForVendor = deviceId
    self.tokenSendLimiter.shouldSendResult = true

    let expectation = XCTestExpectation(description: "result")
    _ = self.manager.didRegisterForRemoteNotifications(deviceToken: token).tap { result in
      switch result {
      case .fulfilled:
        break
      case .rejected:
        XCTFail("Expected fulfilled")
      }

      expectation.fulfill()
    }

    self.wait(for: expectation)
    XCTAssertEqual(self.tokenSendLimiter.shouldSendCallCount, 1)
    XCTAssertEqual(self.tokenSendLimiter.registerSendCallCount, 1)

    let arg = self.api.sendNotificationTokenArg
    XCTAssertEqual(arg?.deviceId, deviceId)
    XCTAssertEqual(arg?.token, tokenToSend)
  }
}
