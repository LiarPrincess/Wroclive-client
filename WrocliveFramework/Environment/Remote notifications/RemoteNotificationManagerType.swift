// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import PromiseKit
import UserNotifications

public enum RemoteNotificationAuthorization {
  case granted
  case notGranted
}

public protocol RemoteNotificationManagerType: AnyObject {

  var delegate: RemoteNotificationManagerDelegate? { get set }

  /// Requests the notification settings for this app.
  func getSettings() -> Guarantee<RemoteNotificationSettings>

  /// Request authorization for showing notifications.
  func requestAuthorization() -> Promise<RemoteNotificationAuthorization>

  /// Register to receive remote notifications through Apple Push Notification service.
  func registerForRemoteNotifications()

  /// App successfully registered with Apple Push Notification service.
  func didRegisterForRemoteNotifications(deviceToken: Data) -> Promise<Void>

  /// Apple Push Notification service cannot successfully complete the registration process.
  ///
  /// This may happen when:
  /// - there is no internet connection
  /// - app is not properly configured for remote notifications
  func didFailToRegisterForRemoteNotifications(error: Error)
}
