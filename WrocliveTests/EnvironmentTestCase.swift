// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import WrocliveFramework
@testable import WrocliveFramework

// swiftlint:disable force_cast

/// Test case that uses AppEnvironment
/// It requires RxTestCase because of schedulers
protocol EnvironmentTestCase: RxTestCase { }

extension EnvironmentTestCase {

  var bundleMock:        BundleManagerMock       { return AppEnvironment.bundle       as! BundleManagerMock}
  var debugMock:         DebugManagerMock        { return AppEnvironment.debug        as! DebugManagerMock}
  var deviceMock:        DeviceManagerMock       { return AppEnvironment.device       as! DeviceManagerMock}
  var logMock:           LogManagerMock          { return AppEnvironment.log          as! LogManagerMock}
  var networkMock:       NetworkManagerMock      { return AppEnvironment.network      as! NetworkManagerMock}
  var schedulersMock:    SchedulersManagerMock   { return AppEnvironment.schedulers   as! SchedulersManagerMock}
  var storageMock:       StorageManagerMock      { return AppEnvironment.storage      as! StorageManagerMock}
  var userLocationMock:  UserLocationManagerMock { return AppEnvironment.userLocation as! UserLocationManagerMock}
  var configurationMock: Configuration  { return AppEnvironment.configuration }

  func setUpEnvironment() {
    AppEnvironment.push(
      Environment(
        bundle:        BundleManagerMock(),
        debug:         DebugManagerMock(),
        device:        DeviceManagerMock(),
        log:           LogManagerMock(),
        network:       NetworkManagerMock(),
        schedulers:    SchedulersManagerMock(main: self.scheduler),
        storage:       StorageManagerMock(),
        userLocation:  UserLocationManagerMock(self.scheduler),
        configuration: Configuration()
      )
    )
  }

  func tearDownEnvironment() {
    AppEnvironment.pop()
  }
}
