// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import PromiseKit
import UserNotifications
import WrocliveTestsShared
@testable import WrocliveFramework

final class AppleUserNotificationCenterMock: AppleUserNotificationCenter {

  // swiftlint:disable:next weak_delegate
  var delegate: UNUserNotificationCenterDelegate?

  func getNotificationSettings(completionHandler: @escaping (UNNotificationSettings) -> Void) {
    fatalError()
  }

  var requestAuthorizationCallCount = 0
  var requestAuthorizationOptions: UNAuthorizationOptions?
  var requestAuthorizationHandlerArgs: (Bool, Error?)?

  func requestAuthorization(options: UNAuthorizationOptions,
                            completionHandler: @escaping (Bool, Error?) -> Void) {
    self.requestAuthorizationCallCount += 1
    self.requestAuthorizationOptions = options

    guard let args = self.requestAuthorizationHandlerArgs else {
      fatalError("Forgot to mock 'self.requestAuthorizationHandlerArgs'?")
    }

    completionHandler(args.0, args.1)
  }
}
