// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

final class RemoteNotificationManagerTests: XCTestCase {

  var api: ApiMock!
  var device: DeviceManagerMock!
  var notificationCenter: AppleUserNotificationCenterMock!
  var tokenSendLimiter: RemoteNotificationTokenSendLimiterMock!
  var manager: RemoteNotificationManager!

  override func setUp() {
    super.setUp()

    self.api = ApiMock()
    self.device = DeviceManagerMock()
    self.notificationCenter = AppleUserNotificationCenterMock()
    self.tokenSendLimiter = RemoteNotificationTokenSendLimiterMock()

    let bundle = BundleManagerMock()
    let log = LogManager(bundle: bundle)

    self.manager = RemoteNotificationManager(
      api: self.api,
      device: self.device,
      tokenSendLimiter: self.tokenSendLimiter,
      notificationCenter: self.notificationCenter,
      log: log
    )
  }

  func wait(for expectation: XCTestExpectation, timeout: TimeInterval = 2.0) {
    self.wait(for: [expectation], timeout: timeout)
  }
}
