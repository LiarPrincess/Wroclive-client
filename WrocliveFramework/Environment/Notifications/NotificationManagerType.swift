// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import PromiseKit
import UserNotifications

public protocol NotificationCenterDelegate: UNUserNotificationCenterDelegate {
  func registerForRemoteNotifications()
}

public protocol NotificationManagerType {

  /// Requests the notification settings for this app.
  func getSettings() -> Guarantee<NotificationSettings>

  /// Request authorization for showing notifications.
  func requestAuthorization() -> Promise<Void>

  /// Registers to receive remote notifications through Apple Push Notification service.
  func registerForRemoteNotifications(delegate: NotificationCenterDelegate)

  /// App successfully registered with Apple Push Notification service.
  func didRegisterForRemoteNotifications(deviceToken: Data)

  /// Apple Push Notification service cannot successfully complete the registration process.
  ///
  /// This may happen when:
  /// - there is no internet connection
  /// - app is not properly configured for remote notifications
  func didFailToRegisterForRemoteNotifications(error: Error)
}
