// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import WrocliveFramework
@testable import WrocliveFramework

// swiftlint:disable force_cast

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

  var userLocationManager: UserLocationManagerMock {
    return self.environment.userLocation as! UserLocationManagerMock
  }

  var configuration: Configuration {
    return self.environment.configuration
  }

  func setUpEnvironment() {
    let bundle = BundleManagerMock()
    self.environment = Environment(api: ApiMock(),
                                   bundle: bundle,
                                   debug: DebugManagerMock(),
                                   device: DeviceManagerMock(),
                                   log: LogManager(bundle: bundle),
                                   storage: StorageManagerMock(),
                                   userLocation: UserLocationManagerMock(),
                                   configuration: Configuration())
  }
}
