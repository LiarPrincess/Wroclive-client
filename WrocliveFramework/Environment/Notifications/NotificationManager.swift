// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import os.log
import PromiseKit
import UserNotifications

// swiftlint:disable line_length

public protocol AppleUserNotificationCenter: AnyObject {
  var delegate: UNUserNotificationCenterDelegate? { get set }

  func getNotificationSettings(completionHandler: @escaping (UNNotificationSettings) -> Void)
  func requestAuthorization(options: UNAuthorizationOptions,
                            completionHandler: @escaping (Bool, Error?) -> Void)
}

extension UNUserNotificationCenter: AppleUserNotificationCenter {}

public class NotificationManager: NotificationManagerType {

  private let api: ApiType
  private let device: DeviceManagerType
  private let logManager: LogManagerType
  private let tokenSendLimiter: NotificationTokenSendLimiterType
  private let notificationCenter: AppleUserNotificationCenter

  private var log: OSLog {
    return self.logManager.notification
  }

  public init(api: ApiType,
              device: DeviceManagerType,
              tokenSendLimiter: NotificationTokenSendLimiterType,
              notificationCenter: AppleUserNotificationCenter,
              log: LogManagerType) {
    self.api = api
    self.device = device
    self.logManager = log
    self.tokenSendLimiter = tokenSendLimiter
    self.notificationCenter = notificationCenter
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

  public func requestAuthorization() -> Promise<NotificationAuthorization> {
    return self.requestAuthorizationPromise()
      .map { granted, error in
        if let error = error {
          os_log("Authorization request failed: %{public}@",
                 log: self.log,
                 type: .info,
                 error.localizedDescription)

          throw error
        }

        switch granted {
        case true:
          os_log("Authorization granted", log: self.log, type: .info)
          return NotificationAuthorization.granted
        case false:
          os_log("Authorization not granted", log: self.log, type: .info)
          return NotificationAuthorization.notGranted
        }
      }
      .ensureOnMain()
  }

  private func requestAuthorizationPromise() -> Promise<(Bool, Error?)> {
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
    // TODO: Time sensitive notifications
    let options: UNAuthorizationOptions = [.alert]

    return Promise { resolver in
      self.notificationCenter.requestAuthorization(options: options) { granted, error in
        let tuple = (granted, error)
        resolver.fulfill(tuple)
      }
    }
  }

  // MARK: - Remote notifications

  public func registerForRemoteNotifications(delegate: NotificationCenterDelegate) {
    assert(self.notificationCenter.delegate == nil)
    delegate.registerForRemoteNotifications()
    self.notificationCenter.delegate = delegate
  }

  public enum RegisterForRemoteNotificationsError: Error {
    case deviceIdentifierNotPresent
    case sendRateLimitExhausted
  }

  public func didRegisterForRemoteNotifications(deviceToken: Data) -> Promise<Void> {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()

#if DEBUG
    os_log("Token: %{public}@", log: self.log, type: .debug, token)
#endif

    guard let deviceId = self.device.identifierForVendor else {
      os_log("Failed to send token: deviceId not present", log: self.log, type: .error)
      let error = RegisterForRemoteNotificationsError.deviceIdentifierNotPresent
      return Promise(error: error)
    }

    guard self.tokenSendLimiter.shouldSend(token: token) else {
      os_log("Failed to send token: rate limitter", log: self.log, type: .info)
      let error = RegisterForRemoteNotificationsError.sendRateLimitExhausted
      return Promise(error: error)
    }

    return self.api.sendNotificationToken(deviceId: deviceId, token: token)
      .tap { result in
        switch result {
        case .fulfilled:
          os_log("Token send succesfully", log: self.log, type: .info)
          self.tokenSendLimiter.registerSend(token: token)
        case .rejected(let error):
          os_log("Failed to send token: %{public}@",
                 log: self.log,
                 type: .error,
                 error.localizedDescription)
        }
      }
  }

  public func didFailToRegisterForRemoteNotifications(error: Error) {
    os_log("Failed to register for remote notifications: %{public}@",
           log: self.log,
           type: .error,
           error.localizedDescription)
  }
}
