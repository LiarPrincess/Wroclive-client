// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

private struct RegisterError: Equatable, Error {
  let message: String
}

extension RemoteNotificationManagerTests {

  func test_didFailToRegisterForRemoteNotifications() {
    let error = RegisterError(message: "MESSAGE")
    self.manager.didFailToRegisterForRemoteNotifications(error: error)

    XCTAssertEqual(self.tokenSendLimiter.shouldSendCallCount, 0)
    XCTAssertEqual(self.tokenSendLimiter.registerSendCallCount, 0)
    XCTAssertEqual(self.api.sendNotificationTokenCallCount, 0)
  }
}
