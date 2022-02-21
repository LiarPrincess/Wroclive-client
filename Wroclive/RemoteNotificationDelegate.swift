// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import os.log
import ReSwift
import WrocliveFramework

// swiftlint:disable discouraged_optional_collection

internal final class RemoteNotificationDelegate: RemoteNotificationManagerDelegate {

  private let environment: Environment
  internal var coordinator: AppCoordinator?

  private var log: OSLog {
    return self.environment.log.app
  }

  internal init(environment: Environment) {
    self.environment = environment
  }

  // MARK: - Did finish launching

  internal enum LaunchRemoteNotificationUrl {
    case url(String)
    case noRemoteNotification
    case noUrl
  }

  internal static func getRemoteNotificationUrl(
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> LaunchRemoteNotificationUrl {
    guard let userInfo = launchOptions?[.remoteNotification] as? [String: AnyObject] else {
      return .noRemoteNotification
    }

    guard let url = RemoteNotificationDelegate.getUrl(userInfo: userInfo) else {
      return .noUrl
    }

    return .url(url)
  }

  // MARK: - Will present

  /// See `RemoteNotificationManagerDelegate` for documentation.
  internal func remoteNotificationManager(
    _ manager: RemoteNotificationManagerType,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    os_log("remoteNotificationManager(_:willPresent:)", log: self.log, type: .info)
    let options = self.showEvenIfWeAreActiveApplication(notification: notification)
    completionHandler(options)
  }

  private func showEvenIfWeAreActiveApplication(
    notification: UNNotification
  ) -> UNNotificationPresentationOptions {
    let request = notification.request.content
    var result: UNNotificationPresentationOptions = []

    if request.badge != nil {
      result.insert(.badge)
    }

    if request.sound != nil {
      result.insert(.sound)
    }

    let allEmpty = request.title.isEmpty
    && request.subtitle.isEmpty
    && request.body.isEmpty

    if !allEmpty {
      if #available(iOS 14.0, *) {
        result.insert(.banner)
      } else {
        result.insert(.alert)
      }
    }

    return result
  }

  // MARK: - Did receive response

  /// See `RemoteNotificationManagerDelegate` for documentation.
  internal func remoteNotificationManager(
    _ manager: RemoteNotificationManagerType,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    os_log("remoteNotificationManager(_:didReceive:)", log: self.log, type: .info)

    switch response.actionIdentifier {
    case UNNotificationDefaultActionIdentifier:
      self.openBrowser(notification: response.notification)
    case UNNotificationDismissActionIdentifier:
      break
    default:
      break
    }

    completionHandler()
  }

  private func openBrowser(notification: UNNotification) {
    let userInfo = notification.request.content.userInfo
    guard let url = RemoteNotificationDelegate.getUrl(userInfo: userInfo) else {
      os_log("Push notification does not contain url'",
             log: self.log,
             type: .info)

      return
    }

    os_log("Push notification contains url: '%{public}@'",
           log: self.log,
           type: .info,
           url)

    self.coordinator?.openUrlFromPushNotification(url: url)
  }

  private static func getUrl(userInfo: [AnyHashable: Any]) -> String? {
    return userInfo["url"] as? String
  }
}
