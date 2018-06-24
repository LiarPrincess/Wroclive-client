// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
import Result
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

// swiftlint:disable implicitly_unwrapped_optional

class TestCase: XCTestCase {

  var apiManager:          ApiManagerMock!
  var storageManager:      StorageManagerMock!
  var schedulerManager:    SchedulerManagerMock!
  var liveManager:         LiveManagerMock!
  var userLocationManager: UserLocationManagerMock!

  var scheduler:  TestScheduler!
  var disposeBag: DisposeBag!

  override func setUp() {
    super.setUp()
    self.scheduler  = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()

    self.apiManager          = ApiManagerMock(self.scheduler)
    self.storageManager      = StorageManagerMock()
    self.schedulerManager    = SchedulerManagerMock(main: self.scheduler, mainAsync: self.scheduler)
    self.liveManager         = LiveManagerMock(self.scheduler)
    self.userLocationManager = UserLocationManagerMock(self.scheduler)

    AppEnvironment.push(bundle:        BundleManager(),
                        device:        DeviceManager(),
                        theme:         ThemeManager(),
                        storage:       self.storageManager,
                        variables:     EnvironmentVariables(),
                        schedulers:    self.schedulerManager,
                        api:           self.apiManager,
                        live:          self.liveManager,
                        userLocation:  self.userLocationManager,
                        debug:         DebugManager())
  }

  override func tearDown() {
    super.tearDown()
    self.scheduler = nil
    self.disposeBag = nil
    AppEnvironment.pop()
  }

  func startScheduler() {
    self.scheduler.start()
  }
}
