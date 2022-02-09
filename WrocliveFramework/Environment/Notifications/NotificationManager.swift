// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import os.log
import PromiseKit
import UserNotifications

// swiftlint:disable line_length

public class NotificationManager: NotificationManagerType {

  private let api: ApiType
  private let device: DeviceManagerType
  private let logManager: LogManagerType
  private let tokenSendLimiter: NotificationTokenSendLimiterType
  private lazy var notificationCenter = UNUserNotificationCenter.current()

  private var log: OSLog {
    return self.logManager.notification
  }

  public init(api: ApiType,
              device: DeviceManagerType,
              tokenSendLimiter: NotificationTokenSendLimiterType,
              log: LogManagerType) {
    self.api = api
    self.device = device
    self.logManager = log
    self.tokenSendLimiter = tokenSendLimiter
  }

  // MARK: - Settings

  public func getSettings() -> Guarantee<NotificationSettings> {
    return Guarantee { resolve in
      self.notificationCenter.getNotificationSettings { settings in
        let result = NotificationSettings(settings: settings)
        resolve(result)
      }
    }
    .ensureOnMain()
  }

  // MARK: - Authorization

  public func requestAuthorization() -> Promise<Void> {
    return self.requestAuthorizationPromise()
      .tap { result in
        switch result {
        case .fulfilled(.granted):
          os_log("Authorization granted", log: self.log, type: .info)
        case .fulfilled(.notGranted):
          os_log("Authorization not granted", log: self.log, type: .info)
        case .rejected(let error):
          os_log("Authorization request failed: %{public}@",
                 log: self.log,
                 type: .info,
                 error.localizedDescription)
        }
      }
      .asVoid()
      .ensureOnMain()
  }

  private enum AuthorizationPromiseValue {
    case granted
    case notGranted
  }

  private func requestAuthorizationPromise() -> Promise<AuthorizationPromiseValue> {
    // Enabled:
    // - alert - we want to show the alert on the lock screen.
    //
    // Not enabled:
    // - badge - visual noise.
    // - sound - we are not that important.
    // - criticalAlert - we are not a medical device.
    // - provisional - showing alerts on the LOCK SCREEN is crucial for this whole
    //   funcionality. If we selected 'provisional' then we would appear only in
    //   the notification center.
    // - providesAppNotificationSettings - we do not have a specific settings, see:
    //   https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications
    // TODO: [APN] timeSensitive
    let options: UNAuthorizationOptions = [.alert]

    return Promise { resolver in
      self.notificationCenter.requestAuthorization(options: options) { granted, error in
        if let error = error {
          resolver.reject(error)
        }

        let result: AuthorizationPromiseValue = granted ? .granted : .notGranted
        resolver.fulfill(result)
      }
    }
  }

  // MARK: - Remote notifications

  public func registerForRemoteNotifications(delegate: NotificationCenterDelegate) {
    assert(self.notificationCenter.delegate == nil)
    delegate.registerForRemoteNotifications()
    self.notificationCenter.delegate = delegate
  }

  public func didRegisterForRemoteNotifications(deviceToken: Data) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()

#if DEBUG
    os_log("Token: %{public}@", log: self.log, type: .debug, token)
#endif

    guard let deviceId = self.device.identifierForVendor else {
      os_log("Failed to send token: deviceId not present", log: self.log, type: .error)
      return
    }

    guard self.tokenSendLimiter.shouldSend(token: token) else {
      os_log("Failed to send token: rate limitter", log: self.log, type: .info)
      return
    }

    self.api.sendNotificationToken(deviceId: deviceId, token: token)
      .tap { result in
        switch result {
        case .fulfilled:
          os_log("Token send succesfully", log: self.log, type: .info)
        case .rejected(let error):
          os_log("Failed to send token: %{public}@",
                 log: self.log,
                 type: .error,
                 error.localizedDescription)
        }
      }
      .done { _ in self.tokenSendLimiter.registerSend(token: token) }
      .cauterize()
  }

  public func didFailToRegisterForRemoteNotifications(error: Error) {
    os_log("Failed to register for remote notifications: %{public}@",
           log: self.log,
           type: .error,
           error.localizedDescription)
  }
}
