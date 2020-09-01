// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

@testable import WrocliveFramework

// swiftlint:disable force_cast
// swiftlint:disable implicitly_unwrapped_optional

/// Test case that uses `Environment`.
protocol EnvironmentTestCase: AnyObject {
  var environment: Environment! { get set }
}

extension EnvironmentTestCase {

  var apiMock: ApiMock {
    return self.environment.api as! ApiMock
  }

  var bundleManager: BundleManagerMock {
    return self.environment.bundle as! BundleManagerMock
  }

  var deviceManager: DeviceManagerMock {
    return self.environment.device as! DeviceManagerMock
  }

  var storageManager: StorageManagerMock {
    return self.environment.storage as! StorageManagerMock
  }

  var userDefaultsManager: UserDefaultsManagerMock {
    return self.environment.userDefaults as! UserDefaultsManagerMock
  }

  var userLocationManager: UserLocationManagerMock {
    return self.environment.userLocation as! UserLocationManagerMock
  }

  var configuration: Configuration {
    return self.environment.configuration
  }

  func setUpEnvironment() {
    let bundle = BundleManagerMock()

    let configuration = Configuration(
      websiteUrl: "websiteUrl",
      githubUrl: "githubUrl",
      reportErrorRecipient: "reportErrorRecipient",
      appStore: .init(
        url: "appStore-url",
        writeReview: "appStore-writeReview"
      ),
      timing: .init(
        vehicleLocationUpdateInterval: TimeInterval(3.0),
        locationAuthorizationPromptDelay: TimeInterval(5.0)
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
      configuration: configuration
    )
  }
}
