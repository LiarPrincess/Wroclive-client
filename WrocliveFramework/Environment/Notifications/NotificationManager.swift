// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import os.log
import PromiseKit
import UserNotifications

public class NotificationManager: NotificationManagerType {

  private let logManager: LogManagerType

  private var log: OSLog {
    return self.logManager.notification
  }

  public init(log: LogManagerType) {
    self.logManager = log
  }

  // MARK: - Settings

  public func getSettings() -> Guarantee<NotificationSettings> {
    let result = NotificationSettings(
      authorization: .notDetermined,
      notificationCenter: .disabled,
      lockScreen: .disabled,
      alert: .disabled,
      alertStyle: .none,
      sound: .disabled,
      criticalAlert: .setting(.disabled),
      timeSensitive: .setting(.disabled)
    )

    return Guarantee.value(result)
  }

  // MARK: - Authorization

  public func requestAuthorization() -> Promise<Void> {
    return Promise.value()
  }

  // MARK: - Remote notifications

  public func registerForRemoteNotifications(delegate: NotificationCenterDelegate) {
  }

  public func didRegisterForRemoteNotifications(deviceToken: Data) {
  }

  public func didFailToRegisterForRemoteNotifications(error: Error) {
  }
}
