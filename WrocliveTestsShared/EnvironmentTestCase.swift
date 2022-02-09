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

  public var notificationManager: NotificationManagerMock {
    return self.environment.notification as! NotificationManagerMock
  }

  public var configuration: Configuration {
    return self.environment.configuration
  }

  public func setUpEnvironment() {
    let bundle = BundleManagerMock()

    let configuration = Configuration(
      apiUrl: "apiUrl",
      githubUrl: "githubUrl",
      privacyPolicyUrl: "privacyPolicyUrl",
      reportErrorRecipient: "reportErrorRecipient",
      appStore: .init(
        url: "appStore-url",
        writeReview: "appStore-writeReview"
      ),
      timing: .init(
        vehicleLocationUpdateInterval: TimeInterval(5.0),
        locationAuthorizationPromptDelay: TimeInterval(2.0),
        notificationAuthorizationPromptDelay: TimeInterval(4.0)
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
      notification: NotificationManagerMock(),
      configuration: configuration
    )
  }
}