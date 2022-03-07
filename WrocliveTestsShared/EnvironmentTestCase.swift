// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

@testable import WrocliveFramework

// swiftlint:disable force_cast
// swiftlint:disable implicitly_unwrapped_optional

/// Test case that uses `Environment`.
public protocol EnvironmentTestCase: AnyObject {
  var environment: Environment! { get set }
}

extension EnvironmentTestCase {

  public var apiMock: ApiMock {
    return self.environment.api as! ApiMock
  }

  public var bundleManager: BundleManagerMock {
    return self.environment.bundle as! BundleManagerMock
  }

  public var deviceManager: DeviceManagerMock {
    return self.environment.device as! DeviceManagerMock
  }

  public var storageManager: StorageManagerMock {
    return self.environment.storage as! StorageManagerMock
  }

  public var userDefaultsManager: UserDefaultsManagerMock {
    return self.environment.userDefaults as! UserDefaultsManagerMock
  }

  public var userLocationManager: UserLocationManagerMock {
    return self.environment.userLocation as! UserLocationManagerMock
  }

  public var remoteNotificationsManager: RemoteNotificationManagerMock {
    return self.environment.remoteNotifications as! RemoteNotificationManagerMock
  }

  public var configuration: Configuration {
    return self.environment.configuration
  }

  public func setUpEnvironment() {
    let bundle = BundleManagerMock()

    let configuration = Configuration(
      apiUrl: "API_URL",
      githubUrl: "GITHUB_URL",
      privacyPolicyUrl: "PRIVACY_POLICY_URL",
      reportErrorMailRecipient: "REPORT_ERROR_RECIPIENT",
      appStore: .init(
        url: "APP_STORE_URL",
        writeReviewUrl: "APP_STORE_WRITE_REVIEW_URL"
      ),
      timing: .init(
        vehicleLocationUpdateInterval: 5.0,
        locationAuthorizationPromptDelay: 2.0,
        maxWaitingTimeBeforeShowingNotificationPrompt: 10.0
      )
    )

    self.environment = Environment(
      api: ApiMock(),
      bundle: bundle,
      debug: DebugManagerMock(),
      device: DeviceManagerMock(),
      log: LogManager(bundle: bundle),
      storage: StorageManagerMock(),
      userDefaults: UserDefaultsManagerMock(),
      userLocation: UserLocationManagerMock(),
      remoteNotifications: RemoteNotificationManagerMock(),
      configuration: configuration
    )
  }
}
