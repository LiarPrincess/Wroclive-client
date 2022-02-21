// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UserNotifications

public protocol RemoteNotificationManagerDelegate: AnyObject {

  /// The method will be called on the delegate only if the application is in the foreground!
  ///
  /// The application can choose to have the notification presented as a sound,
  /// badge, alert and/or in the notification list. This decision should be based
  /// on whether the information in the notification is otherwise visible to the user.
  func remoteNotificationManager(
    _ manager: RemoteNotificationManagerType,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  )

  /// The method will be called on the delegate when the user responded to the notification
  /// by opening the application, dismissing the notification or choosing a `UNNotificationAction`.
  ///
  /// The delegate must be set before the application returns from
  /// `application:didFinishLaunchingWithOptions:`.
  func remoteNotificationManager(
    _ manager: RemoteNotificationManagerType,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  )
}
