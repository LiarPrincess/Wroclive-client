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
    self.viewModel.mapCenter.drive(mapCenterObserver).disposed(by: self.disposeBag)

    self.vehiclesObserver = self.scheduler.createObserver([Vehicle].self)
    self.viewModel.vehicles.drive(vehiclesObserver).disposed(by: self.disposeBag)

    self.showAlertObserver = self.scheduler.createObserver(MapViewAlert.self)
    self.viewModel.showAlert.drive(showAlertObserver).disposed(by: self.disposeBag)
  }

  // MARK: - Events

  typealias TrackingModeChangedEvent = RecordedEvent<MKUserTrackingMode>

  func mockTrackingModeChangedEvents(_ events: TrackingModeChangedEvent...) {
    let rxEvents = events.map { Recorded.next($0.time, $0.data) }

    self.scheduler.createHotObservable(rxEvents)
      .bind(to: self.viewModel.didChangeTrackingMode)
      .disposed(by: self.disposeBag)
  }

  func mockAuthorizationEvents(_ events: AuthorizationEvent...) {
    self.userLocationManager.mockAuthorizationEvents(events)
  }

  func mockUserLocationEvents(_ events: UserLocationEvent...) {
    self.userLocationManager.mockUserLocationEvents(events)
  }

  func mockUserLocationError(_ event: UserLocationErrorEvent) {
    self.userLocationManager.mockUserLocationError(event)
  }

  func mockVehicleResponseEvents(_ events: VehicleResponseEvent...) {
    self.liveManager.mockVehicleResponses(events)
  }

  func mockViewDidAppearEvent(at time: TestTime) {
    let rxEvents = [next(time, ())]

    self.scheduler.createHotObservable(rxEvents)
      .bind(to: self.viewModel.viewDidAppear)
      .disposed(by: self.disposeBag)
  }
}
