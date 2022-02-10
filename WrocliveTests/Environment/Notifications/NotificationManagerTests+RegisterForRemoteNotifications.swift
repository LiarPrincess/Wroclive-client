// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

private final class NotificationCenterDelegateMock: NSObject, NotificationCenterDelegate {

  fileprivate var registerForRemoteNotificationsCallCount = 0

  func registerForRemoteNotifications() {
    self.registerForRemoteNotificationsCallCount += 1
  }
}

extension NotificationManagerTests {

  func test_registerForRemoteNotifications() {
    let delegate = NotificationCenterDelegateMock()
    self.manager.registerForRemoteNotifications(delegate: delegate)

    XCTAssert(self.notificationCenter.delegate === delegate)
    XCTAssertEqual(delegate.registerForRemoteNotificationsCallCount, 1)
  }
}
