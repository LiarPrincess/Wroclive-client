//
// Created by Michal Matuszczyk
// Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import XCTest
import MapKit
import Result
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import Wroclive

// swiftlint:disable file_length
// swiftlint:disable implicitly_unwrapped_optional

private typealias Defaults = MapViewControllerConstants.Defaults

final class MapViewModelTests: XCTestCase {

  // MARK: - Properties

  var mapManager:   MapManagerMock!
  var userLocation: UserLocationManagerMock!

  var viewModel:     MapViewModel!
  var testScheduler: TestScheduler!
  var disposeBag:    DisposeBag!

  // MARK: - Init

  override func setUp() {
    super.setUp()
    self.testScheduler = TestScheduler(initialClock: 0)
    self.disposeBag    = DisposeBag()

    self.mapManager   = MapManagerMock()
    self.userLocation = UserLocationManagerMock()
    AppEnvironment.push(userLocation: self.userLocation, map: self.mapManager)
  }

  override func tearDown() {
    super.tearDown()
    self.testScheduler = nil
    self.disposeBag = nil
    AppEnvironment.pop()
  }

  // MARK: - Map type

  func test_mapType_comesFromManager() {
    self.viewModel = MapViewModel()

    let event0 = next(100, MapType.standard)
    let event1 = next(200, MapType.satellite)
    let event2 = next(300, MapType.hybrid)
    self.simulateMapTypeEvents(event0, event1, event2)

    let observer = self.testScheduler.createObserver(MKMapType.self)
    self.viewModel.outputs.mapType.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(100, MKMapType.standard),
      next(200, MKMapType.satellite),
      next(300, MKMapType.hybrid)
    ]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.mapManager, mapType: 1)
  }

  // MARK: - Map center

  func test_mapCenter_startsWithDefault() {
    self.viewModel = MapViewModel()

    self.simulateAuthorizationEvents()

    let observer = self.testScheduler.createObserver(CLLocationCoordinate2D.self)
    self.viewModel.outputs.mapCenter.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    XCTAssertEqual(observer.events, [next(0, Defaults.location)])
    XCTAssertOperationCount(self.userLocation, current: 0, authorization: 1)
  }

  // MARK: Map center - Did appear

  func test_didAppear_withLocationAuthorization_centersUserLocation() {
    self.viewModel = MapViewModel()

    self.simulateAuthorizationEvents(next(0, .authorizedWhenInUse))

    let location0 = next(100, CLLocationCoordinate2D(latitude: 3.0, longitude:  6.0))
    let location1 = next(200, CLLocationCoordinate2D(latitude: 9.0, longitude: 12.0))
    self.simulateUserLocationEvents(location0, location1)

    self.simulateViewDidAppearEvents(at: 50)

    let observer = self.testScheduler.createObserver(CLLocationCoordinate2D.self)
    self.viewModel.outputs.mapCenter.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, Defaults.location), location0]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.userLocation, current: 1, authorization: 1)
  }

  func test_didAppear_withDeniedLocationAuthorization_doesNotUpdateCenter() {
    self.viewModel = MapViewModel()

    self.simulateAuthorizationEvents(next(0, .denied))

    let location0 = next(100, CLLocationCoordinate2D(latitude: 3.0, longitude:  6.0))
    let location1 = next(200, CLLocationCoordinate2D(latitude: 9.0, longitude: 12.0))
    self.simulateUserLocationEvents(location0, location1)

    self.simulateViewDidAppearEvents(at: 50)

    let observer = self.testScheduler.createObserver(CLLocationCoordinate2D.self)
    self.viewModel.outputs.mapCenter.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, Defaults.location)]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.userLocation, current: 0, authorization: 1)
  }

  func test_didAppear_withUserLocationError_doesNotCrash() {
    self.viewModel = MapViewModel()

    self.simulateAuthorizationEvents(next(0, .authorizedWhenInUse))

    let location0 = error(100, UserLocationError.generalError, CLLocationCoordinate2D.self)
    let location1 = next(200, CLLocationCoordinate2D(latitude: 9.0, longitude: 12.0))
    self.simulateUserLocationEvents(location0, location1)

    self.simulateViewDidAppearEvents(at: 50)

    let observer = self.testScheduler.createObserver(CLLocationCoordinate2D.self)
    self.viewModel.outputs.mapCenter.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, Defaults.location)]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.userLocation, current: 1, authorization: 1)
  }

  // MARK: Map center - Changing authorization

  func test_changingAuthorization_fromNonDetermined_toAuthorized_centersUserLocation() {
    self.viewModel = MapViewModel()

    self.simulateAuthorizationEvents(next(0, .notDetermined), next(100, .authorizedWhenInUse))

    let location0 = next(150, CLLocationCoordinate2D(latitude: 3.0, longitude:  6.0))
    let location1 = next(250, CLLocationCoordinate2D(latitude: 9.0, longitude: 12.0))
    self.simulateUserLocationEvents(location0, location1)

    let observer = self.testScheduler.createObserver(CLLocationCoordinate2D.self)
    self.viewModel.outputs.mapCenter.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, Defaults.location), location0]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.userLocation, current: 1, authorization: 1)
  }

  func test_changingAuthorization_fromNonDetermined_toDenied_doesNotUpdateCenter() {
    self.viewModel = MapViewModel()

    self.simulateAuthorizationEvents(next(0, .notDetermined), next(100, .denied))

    let location0 = next(150, CLLocationCoordinate2D(latitude: 3.0, longitude:  6.0))
    let location1 = next(250, CLLocationCoordinate2D(latitude: 9.0, longitude: 12.0))
    self.simulateUserLocationEvents(location0, location1)

    let observer = self.testScheduler.createObserver(CLLocationCoordinate2D.self)
    self.viewModel.outputs.mapCenter.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, Defaults.location)]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.userLocation, current: 0, authorization: 1)
  }

  func test_changingAuthorization_fromNonDetermined_toAuthorized_withUserLocationError_doesNotCrash() {
    self.viewModel = MapViewModel()

    self.simulateAuthorizationEvents(next(0, .notDetermined), next(100, .authorizedWhenInUse))

    let location0 = error(100, UserLocationError.generalError, CLLocationCoordinate2D.self)
    let location1 = next(200, CLLocationCoordinate2D(latitude: 9.0, longitude: 12.0))
    self.simulateUserLocationEvents(location0, location1)

    self.simulateViewDidAppearEvents(at: 50)

    let observer = self.testScheduler.createObserver(CLLocationCoordinate2D.self)
    self.viewModel.outputs.mapCenter.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, Defaults.location)]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.userLocation, current: 1, authorization: 1)
  }

  // MARK: - Annotations

  func test_vehicleLocations_comeFromManager() {
    self.viewModel = MapViewModel()

    let vehicles = TestData.vehicles
    let event0 = next(  0, vehicleEvent([]))
    let event1 = next(100, vehicleEvent(vehicles))
    self.simulateVehicleEvents(event0, event1)

    let observer = self.testScheduler.createObserver([Vehicle].self)
    self.viewModel.outputs.vehicleLocations.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, [Vehicle]()), next(100, vehicles)]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.mapManager, vehicleLocations: 1)
  }

  // MARK: - Location authorization

  // MARK: View did appear

  func test_didAppear_withNotDeterminedAuthorization_afterDelay_showsAuthorizationAlert() {
    self.viewModel = MapViewModel()

    self.simulateAuthorizationEvents(next(0, .notDetermined))
    self.simulateViewDidAppearEvents(at: 100)

    let observer = self.testScheduler.createObserver(Void.self)
    self.viewModel.outputs.showLocationAuthorizationAlert.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let authorizationDelay = AppInfo.Timings.locationAuthorizationPromptDelay
    self.waitForLocationAuthorizationAlert(1, timeout: authorizationDelay + 1)

    let expectedEvents = [next(100, ())]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.userLocation, current: 0, authorization: 1)
  }

  func test_didAppear_withLocationAuthorization_afterDelay_doesNotShowAuthorizationAlert() {
    self.viewModel = MapViewModel()

    self.simulateAuthorizationEvents(next(0, .authorizedWhenInUse))
    self.simulateViewDidAppearEvents(at: 100)

    let observer = self.testScheduler.createObserver(Void.self)
    self.viewModel.outputs.showLocationAuthorizationAlert.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let authorizationDelay = AppInfo.Timings.locationAuthorizationPromptDelay
    self.waitForLocationAuthorizationAlert(1, timeout: authorizationDelay + 1)

    XCTAssertEqual(observer.events, [])
    XCTAssertOperationCount(self.userLocation, current: 0, authorization: 1)
  }

  // MARK: Tracking mode

  func test_changingTrackingMode_withNotDeterminedAuthorization_showsAuthorizationAlert() {
    self.viewModel = MapViewModel()

    let event0 = next(100, MKUserTrackingMode.follow)
    let event1 = next(200, MKUserTrackingMode.followWithHeading)
    let event2 = next(300, MKUserTrackingMode.none)
    self.simulateTrackingModeEvents(event0, event1, event2)

    self.simulateAuthorizationEvents(next(0, .notDetermined))

    let observer = self.testScheduler.createObserver(Void.self)
    self.viewModel.outputs.showLocationAuthorizationAlert.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [100, 200, 300].map { next($0, ()) }
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.userLocation, current: 0, authorization: 1)
  }

  func test_changingTrackingMode_withLocationAuthorization_doesNotShowAuthorizationAlert() {
    self.viewModel = MapViewModel()

    let event0 = next(100, MKUserTrackingMode.follow)
    let event1 = next(200, MKUserTrackingMode.followWithHeading)
    let event2 = next(300, MKUserTrackingMode.none)
    self.simulateTrackingModeEvents(event0, event1, event2)

    self.simulateAuthorizationEvents(next(0, .authorizedWhenInUse))

    let observer = self.testScheduler.createObserver(Void.self)
    self.viewModel.outputs.showLocationAuthorizationAlert.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    XCTAssertEqual(observer.events, [])
    XCTAssertOperationCount(self.userLocation, current: 0, authorization: 1)
  }

  // MARK: - Location authorization denied alert

  func test_changingTrackingMode_withDeniedAuthorization_showsAuthorizationDeniedAlert() {
    self.viewModel = MapViewModel()

    self.simulateAuthorizationEvents(next(50, .denied))

    let event0 = next(100, MKUserTrackingMode.follow)
    let event1 = next(200, MKUserTrackingMode.followWithHeading)
    let event2 = next(300, MKUserTrackingMode.none)
    self.simulateTrackingModeEvents(event0, event1, event2)

    let observer = self.testScheduler.createObserver(DeniedLocationAuthorizationAlert.self)
    self.viewModel.outputs.showDeniedLocationAuthorizationAlert.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(100, DeniedLocationAuthorizationAlert.deniedLocationAuthorization),
      next(200, DeniedLocationAuthorizationAlert.deniedLocationAuthorization),
      next(300, DeniedLocationAuthorizationAlert.deniedLocationAuthorization)
    ]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.userLocation, current: 0, authorization: 1)
  }

  func test_changingTrackingMode_withGloballyDeniedAuthorization_showsAuthorizationGloballyDeniedAlert() {
    self.viewModel = MapViewModel()

    self.simulateAuthorizationEvents(next(50, .restricted))

    let event0 = next(100, MKUserTrackingMode.follow)
    let event1 = next(200, MKUserTrackingMode.followWithHeading)
    let event2 = next(300, MKUserTrackingMode.none)
    self.simulateTrackingModeEvents(event0, event1, event2)

    let observer = self.testScheduler.createObserver(DeniedLocationAuthorizationAlert.self)
    self.viewModel.outputs.showDeniedLocationAuthorizationAlert.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(100, DeniedLocationAuthorizationAlert.globallyDeniedLocationAuthorization),
      next(200, DeniedLocationAuthorizationAlert.globallyDeniedLocationAuthorization),
      next(300, DeniedLocationAuthorizationAlert.globallyDeniedLocationAuthorization)
    ]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.userLocation, current: 0, authorization: 1)
  }

  // MARK: - Api alerts

  func test_didAppear_withoutInternet_showsAlert() {
    self.viewModel = MapViewModel()

    let event0 = next(  0, vehicleEvent(ApiError.noInternet))
    let event1 = next(100, vehicleEvent(ApiError.invalidResponse))
    let event2 = next(200, vehicleEvent(ApiError.generalError))
    self.simulateVehicleEvents(event0, event1, event2)

    let observer = self.testScheduler.createObserver(ApiError.self)
    self.viewModel.outputs.showApiErrorAlert.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(0,   ApiError.noInternet),
      next(100, ApiError.invalidResponse),
      next(200, ApiError.generalError)
    ]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.mapManager, vehicleLocations: 1)
  }
}

// MARK: - Test data

extension MapViewModelTests {
  enum TestData {
    static var vehicles: [Vehicle] {
      let line0 = Line(name:  "1", type: .tram, subtype: .regular)
      let line1 = Line(name:  "4", type: .tram, subtype: .regular)
      let line2 = Line(name: "20", type: .tram, subtype: .regular)

      return [
        createVehicle(id: "00", line: line0, num: 3.0),
        createVehicle(id: "01", line: line0, num: 6.0),
        createVehicle(id: "02", line: line0, num: 9.0),

        createVehicle(id: "10", line: line1, num: 12.0),
        createVehicle(id: "11", line: line1, num: 15.0),
        createVehicle(id: "12", line: line1, num: 18.0),

        createVehicle(id: "20", line: line2, num: 21.0),
        createVehicle(id: "21", line: line2, num: 24.0),
        createVehicle(id: "22", line: line2, num: 27.0)
      ]
    }

    private static func createVehicle(id: String, line: Line, num: Double) -> Vehicle {
      return Vehicle(id: id, line: line, latitude: num, longitude: num, angle: num)
    }
  }
}

// MARK: - Events

extension MapViewModelTests {

  // MARK: - User location

  private typealias AuthorizationEvent = Recorded<Event<CLAuthorizationStatus>>
  private typealias UserLocationEvent  = Recorded<Event<CLLocationCoordinate2D>>

  private func simulateAuthorizationEvents(_ events: AuthorizationEvent...) {
    self.userLocation._authorization = self.testScheduler.createHotObservable(events)
  }

  private func simulateUserLocationEvents(_ events: UserLocationEvent...) {
    self.userLocation._current = self.testScheduler.createHotObservable(events)
  }

  // MARK: - Map

  private typealias MapTypeEvent = Recorded<Event<MapType>>

  private func simulateMapTypeEvents(_ events: MapTypeEvent...) {
    self.mapManager._mapType = self.testScheduler.createHotObservable(events)
  }

  private typealias VehicleResponseEvent = Recorded<Event<Result<[Vehicle], ApiError>>>

  private func vehicleEvent(_ vehicles: [Vehicle]) -> Result<[Vehicle], ApiError> {
    return .success(vehicles)
  }

  private func vehicleEvent(_ error: ApiError) -> Result<[Vehicle], ApiError> {
    return .failure(error)
  }

  private func simulateVehicleEvents(_ events: VehicleResponseEvent...) {
    self.mapManager._vehicleLocations = self.testScheduler.createHotObservable(events)
  }

  // MARK: - Tracking mode

  private typealias TrackingModeEvent = Recorded<Event<MKUserTrackingMode>>

  private func simulateTrackingModeEvents(_ events: TrackingModeEvent...) {
    self.testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.trackingModeChanged)
      .disposed(by: self.disposeBag)
  }

  // MARK: - View controller lifecycle

  private func simulateViewDidAppearEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    self.testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.viewDidAppear)
      .disposed(by: self.disposeBag)
  }
}

// MARK: - Helpers

extension MapViewModelTests {

  private func waitForLocationAuthorizationAlert(_ count: Int, timeout: RxTimeInterval) {
    let observable = self.viewModel.outputs.showLocationAuthorizationAlert.asObservable()
    self.wait(for: observable, timeout: timeout, count: count)
  }

  private func wait<Element>(for observable: Observable<Element>, timeout: RxTimeInterval?, count: Int) {
    _ = try? observable
      .take(count)
      .toBlocking(timeout: timeout)
      .toArray()
  }
}

// MARK: - Location

private typealias LocationEvent = Recorded<Event<CLLocationCoordinate2D>>

private func XCTAssertEqual(_ lhs: [LocationEvent], _ rhs: [LocationEvent], file: StaticString = #file, line: UInt = #line) {
  XCTAssertEqual(lhs.count, rhs.count, file: file, line: line)

  for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
    XCTAssertEqual(lhsEvent.time, rhsEvent.time, file: file, line: line)

    let lhsLocation = lhsEvent.value.element!
    let rhsLocation = rhsEvent.value.element!
    XCTAssertEqual(lhsLocation.latitude,  rhsLocation.latitude,  file: file, line: line)
    XCTAssertEqual(lhsLocation.longitude, rhsLocation.longitude, file: file, line: line)
  }
}

private typealias VehicleEvent = Recorded<Event<[Vehicle]>>

private func XCTAssertEqual(_ lhs: [VehicleEvent], _ rhs: [VehicleEvent], file: StaticString = #file, line: UInt = #line) {
  XCTAssertEqual(lhs.count, rhs.count, file: file, line: line)

  for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
    XCTAssertEqual(lhsEvent.time, rhsEvent.time, file: file, line: line)
    XCTAssertEqual(lhsEvent.value.element!, rhsEvent.value.element!, file: file, line: line)
  }
}

private typealias VoidEvent = Recorded<Event<Void>>

private func XCTAssertEqual(_ lhs: [VoidEvent], _ rhs: [VoidEvent], file: StaticString = #file, line: UInt = #line) {
  XCTAssertEqual(lhs.count, rhs.count, file: file, line: line)

  for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
    XCTAssertEqual(lhsEvent.time, rhsEvent.time, file: file, line: line)
  }
}
