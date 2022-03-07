// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UserNotifications

/// Things...
///
/// === User does nothing - notification fades away ===
///
/// - App is in foreground - nothing called
/// - App is in background - nothing called
/// - App is killed - ?
///
/// === User taps the notification - launches the app ===
///
/// - App is in the foreground - user is currently using the app
///   ```
///   userNotificationCenter(_:willPresent:)
///   <show alert>
///
///   userNotificationCenter(_:didReceive:)
///     App state: active
///     Action: default
///   ```
///
/// - App is in the background - it is running, but not in the foreground
///
///   Scenario 1:
///   1. Xcode + launch automatically
///   2. Quit app (don't kill it!)
///   3. Tap push notification
///     ```
///     userNotificationCenter(_:didReceive:)
///       App state: inactive
///       Action: default
///     ```
///
///   Scenario 2:
///   1. Xcode + wait for the executable to be launched
///   2. Tap push notification
///     ```
///     application(_:didFinishLaunchingWithOptions:) <-- for some reason
///
///     userNotificationCenter(_:didReceive:)
///       App state: inactive
///       Action: default
///     ```
///
/// - App is killed - starting app with push notification
///   ```
///    application(_:didFinishLaunchingWithOptions:)
///
///    userNotificationCenter(_:didReceive:)
///      App state: inactive
///      Action: default
///   ```
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
  func remoteNotificationManager(
    _ manager: RemoteNotificationManagerType,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  )
}
