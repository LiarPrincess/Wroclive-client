// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import PromiseKit
@testable import WrocliveFramework

public class RemoteNotificationManagerMock: RemoteNotificationManagerType {

  public var delegate: RemoteNotificationManagerDelegate?

  // MARK: - Settings

  public var settings = RemoteNotificationSettings(
    authorization: .notDetermined,
    notificationCenter: .disabled,
    lockScreen: .disabled,
    alert: .disabled,
    alertStyle: .none,
    sound: .disabled,
    criticalAlert: .setting(.disabled),
    timeSensitive: .setting(.disabled)
  )

  public private(set) var getSettingsCallCount = 0

  public func getSettings() -> Guarantee<RemoteNotificationSettings> {
    self.getSettingsCallCount += 1
    return Guarantee.value(self.settings)
  }

  // MARK: - Authorization

  public var requestAuthorizationResult = RemoteNotificationAuthorization.granted
  public private(set) var requestAuthorizationCallCount = 0

  public func requestAuthorization() -> Promise<RemoteNotificationAuthorization> {
    self.requestAuthorizationCallCount += 1
    return Promise.value(self.requestAuthorizationResult)
  }

  // MARK: - Remote notifications

  public private(set) var registerForRemoteNotificationsCallCount = 0

  public func registerForRemoteNotifications() {
    self.registerForRemoteNotificationsCallCount += 1
  }

  public private(set) var didRegisterForRemoteNotificationsCallCount = 0

  public func didRegisterForRemoteNotifications(deviceToken: Data) -> Promise<Void> {
    self.didRegisterForRemoteNotificationsCallCount += 1
    return Promise.value()
  }

  public private(set) var didFailToRegisterForRemoteNotificationsCallCount = 0

  public func didFailToRegisterForRemoteNotifications(error: Error) {
    self.didFailToRegisterForRemoteNotificationsCallCount += 1
  }
}
