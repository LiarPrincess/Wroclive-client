// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UserNotifications

public struct NotificationSettings {

  // MARK: - Types

  /// Constants indicating whether the app is allowed to schedule notifications.
  public enum Authorization {
    /// The user hasn't yet made a choice about whether the app is allowed to
    /// schedule notifications.
    case notDetermined
    /// The app isn't authorized to schedule or receive notifications.
    case denied
    /// The app is authorized to schedule or receive notifications.
    case authorized
    /// The application is provisionally authorized to post noninterruptive user
    /// notifications.
    case provisional
    /// The app is authorized to schedule or receive notifications for a limited
    /// amount of time.
    case ephemeral
    /// Value added in new iOS version.
    case unknownValue

    fileprivate init(_ status: UNAuthorizationStatus) {
      switch status {
      case .notDetermined: self = .notDetermined
      case .denied: self = .denied
      case .authorized: self = .authorized
      case .provisional: self = .provisional
      case .ephemeral: self = .ephemeral
      @unknown default: self = .unknownValue
      }
    }
  }

  /// Constants that indicate the current status of a notification setting.
  public enum Setting {
    /// The setting is not available to your app.
    case notSupported
    /// The setting is disabled.
    case disabled
    /// The setting is enabled.
    case enabled
    /// Value added in new iOS version.
    case unknownValue

    fileprivate init(_ setting: UNNotificationSetting) {
      switch setting {
      case .notSupported: self = .notSupported
      case .disabled: self = .disabled
      case .enabled: self = .enabled
      @unknown default: self = .unknownValue
      }
    }
  }

  /// Constants that indicate the current status of a notification setting.
  public enum SettingAvailableWithOSVersion {
    case setting(Setting)
    case invalidOSVersion

    fileprivate init(_ setting: UNNotificationSetting) {
      let value = Setting(setting)
      self = .setting(value)
    }
  }

  public enum AlertStyle {
    /// No alert.
    case none
    /// Banner alerts.
    case banner
    /// Modal alerts.
    case alert
    /// Value added in new iOS version.
    case unknownValue

    fileprivate init(_ style: UNAlertStyle) {
      switch style {
      case .none: self = .none
      case .banner: self = .banner
      case .alert: self = .alert
      @unknown default: self = .unknownValue
      }
    }
  }

  // MARK: - Properties

  /// The app's ability to schedule and receive local and remote notifications.
  public let authorization: Authorization
  /// Indicates whether your app’s notifications appear in Notification Center.
  public let notificationCenter: Setting
  /// The setting that indicates whether your app’s notifications appear on a device’s Lock screen.
  public let lockScreen: Setting
  /// The authorization status for displaying alerts.
  public let alert: Setting
  /// The type of alert that the app may display when the device is unlocked.
  public let alertStyle: AlertStyle
  /// The authorization status for playing sounds for incoming notifications.
  public let sound: Setting
  /// The authorization status for playing sounds for critical alerts.
  public let criticalAlert: SettingAvailableWithOSVersion
  /// The setting that indicates the system treats the notification as time-sensitive.
  public let timeSensitive: SettingAvailableWithOSVersion

  // MARK: - Init

  public init(
    authorization: Authorization,
    notificationCenter: Setting,
    lockScreen: Setting,
    alert: Setting,
    alertStyle: AlertStyle,
    sound: Setting,
    criticalAlert: SettingAvailableWithOSVersion,
    timeSensitive: SettingAvailableWithOSVersion
  ) {
    self.authorization = authorization
    self.notificationCenter = notificationCenter
    self.lockScreen = lockScreen
    self.alert = alert
    self.alertStyle = alertStyle
    self.sound = sound
    self.criticalAlert = criticalAlert
    self.timeSensitive = timeSensitive
  }

  public init(settings: UNNotificationSettings) {
    self.authorization = Authorization(settings.authorizationStatus)
    self.notificationCenter = Setting(settings.notificationCenterSetting)
    self.lockScreen = Setting(settings.lockScreenSetting)
    self.alert = Setting(settings.alertSetting)
    self.alertStyle = AlertStyle(settings.alertStyle)
    self.sound = Setting(settings.soundSetting)

    if #available(iOS 12.0, *) {
      self.criticalAlert = SettingAvailableWithOSVersion(settings.criticalAlertSetting)
    } else {
      self.criticalAlert = .invalidOSVersion
    }

    if #available(iOS 15.0, *) {
      self.timeSensitive = SettingAvailableWithOSVersion(settings.timeSensitiveSetting)
    } else {
      self.timeSensitive = .invalidOSVersion
    }
  }
}
