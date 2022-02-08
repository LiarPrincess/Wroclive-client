// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import PromiseKit
@testable import WrocliveFramework

public class NotificationManagerMock: NotificationManagerType {

  public var settings = NotificationSettings(
    authorization: .notDetermined,
    notificationCenter: .disabled,
    lockScreen: .disabled,
    alert: .disabled,
    alertStyle: .none,
    sound: .disabled,
    criticalAlert: .setting(.disabled),
    timeSensitive: .setting(.disabled)
  )

  public var getSettingsCallCount = 0
  public var requestAuthorizationCallCount = 0
  public var registerForRemoteNotificationsCallCount = 0
  public var didRegisterForRemoteNotificationsCallCount = 0
  public var didFailToRegisterForRemoteNotificationsCallCount = 0

  public func getSettings() -> Guarantee<NotificationSettings> {
    self.getSettingsCallCount += 1
    return Guarantee.value(self.settings)
  }

  public func requestAuthorization() -> Promise<Void> {
    self.requestAuthorizationCallCount += 1
    return Promise.value()
  }

  public func registerForRemoteNotifications(delegate: NotificationCenterDelegate) {
    self.registerForRemoteNotificationsCallCount += 1
  }

  public func didRegisterForRemoteNotifications(deviceToken: Data) {
    self.didRegisterForRemoteNotificationsCallCount += 1
  }

  public func didFailToRegisterForRemoteNotifications(error: Error) {
    self.didFailToRegisterForRemoteNotificationsCallCount += 1
  }
}
