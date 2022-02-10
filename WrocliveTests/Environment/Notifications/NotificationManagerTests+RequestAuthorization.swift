// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

private struct AuthorizationError: Equatable, Error {
  let message: String
}

extension NotificationManagerTests {

  func test_requestAuthorization_granted() {
    self.notificationCenter.requestAuthorizationHandlerArgs = (true, nil)

    let expectation = XCTestExpectation(description: "result")
    _ = self.manager.requestAuthorization().tap { result in
      switch result {
      case .fulfilled(.granted):
        break
      case .fulfilled(.notGranted),
           .rejected:
        XCTFail("Expected granted")
      }

      expectation.fulfill()
    }

    self.wait(for: expectation)
    XCTAssertEqual(self.notificationCenter.requestAuthorizationCallCount, 1)
    XCTAssertEqual(self.notificationCenter.requestAuthorizationOptions, [.alert])
  }

  func test_requestAuthorization_notGranted() {
    self.notificationCenter.requestAuthorizationHandlerArgs = (false, nil)

    let expectation = XCTestExpectation(description: "result")
    _ = self.manager.requestAuthorization().tap { result in
      switch result {
      case .fulfilled(.notGranted):
        break
      case .fulfilled(.granted),
           .rejected:
        XCTFail("Expected notGranted")
      }

      expectation.fulfill()
    }

    self.wait(for: expectation)
    XCTAssertEqual(self.notificationCenter.requestAuthorizationCallCount, 1)
    XCTAssertEqual(self.notificationCenter.requestAuthorizationOptions, [.alert])
  }

  func test_requestAuthorization_error() {
    let error = AuthorizationError(message: "MESSAGE")
    self.notificationCenter.requestAuthorizationHandlerArgs = (false, error)

    let expectation = XCTestExpectation(description: "result")
    _ = self.manager.requestAuthorization().tap { result in
      switch result {
      case .fulfilled:
        XCTFail("Expected rejection")
      case .rejected(let e):
        XCTAssertEqual(error, e as? AuthorizationError)
      }

      expectation.fulfill()
    }

    self.wait(for: expectation)
    XCTAssertEqual(self.notificationCenter.requestAuthorizationCallCount, 1)
    XCTAssertEqual(self.notificationCenter.requestAuthorizationOptions, [.alert])
  }
}
