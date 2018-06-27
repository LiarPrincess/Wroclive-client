// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

// swiftlint:disable implicitly_unwrapped_optional

private typealias Defaults = MapViewControllerConstants.Defaults

class MapViewModelTestsBase: TestCase {

  var viewModel: MapViewModel!

  var mapCenterObserver: TestableObserver<CLLocationCoordinate2D>!
  var vehiclesObserver:  TestableObserver<[Vehicle]>!
  var showAlertObserver: TestableObserver<MapViewAlert>!

  override func setUp() {
    super.setUp()

    self.viewModel = MapViewModel()

    self.mapCenterObserver = self.scheduler.createObserver(CLLocationCoordinate2D.self)
    self.viewModel.mapCenter.drive(self.mapCenterObserver).disposed(by: self.disposeBag)

    self.vehiclesObserver = self.scheduler.createObserver([Vehicle].self)
    self.viewModel.vehicles.drive(self.vehiclesObserver).disposed(by: self.disposeBag)

    self.showAlertObserver = self.scheduler.createObserver(MapViewAlert.self)
    self.viewModel.showAlert.drive(self.showAlertObserver).disposed(by: self.disposeBag)
  }

  // MARK: - Events

  func mockTrackingModeChange(at time: TestTime, _ value: MKUserTrackingMode) {
    self.scheduler.scheduleAt(time) {
      self.viewModel.didChangeTrackingMode.onNext(value)
    }
  }

  func mockAuthorization(at time: TestTime, _ value: CLAuthorizationStatus) {
    self.userLocationManager.mockAuthorization(at: time, value)
  }

  func mockUserLocation(at time: TestTime, _ value: Single<CLLocationCoordinate2D>) {
    self.userLocationManager.mockUserLocation(at: time, value)
  }

  func mockVehicleResponse(at time: TestTime, value: Event<[Vehicle]>) {
    self.liveManager.mockVehicleResponse(at: time, value)
  }

  func mockViewDidAppear(at time: TestTime) {
    self.scheduler.scheduleAt(time) {
      self.viewModel.viewDidAppear.onNext()
    }
  }
}
