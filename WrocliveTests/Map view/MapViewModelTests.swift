// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
import ReSwift
import PromiseKit
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

private typealias Defaults = MapViewController.Constants.Defaults

class MapViewModelTests:
  XCTestCase, ReduxTestCase, EnvironmentTestCase, MapViewType {

  var store: Store<AppState>!
  var dispatchedActions: [Action]!
  var environment: Environment!
  var viewModel: MapViewModel!

  var center = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
  var vehicles = [Vehicle]()
  var isShowingDeniedLocationAuthorizationAlert = false
  var isShowingGloballyDeniedLocationAuthorizationAlert = false
  var isShowingApiErrorAlert: ApiError?

  private var setCenterExpectation: XCTestExpectation?

  override func setUp() {
    super.setUp()
    self.setUpRedux()
    self.setUpEnvironment()

    self.center = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    self.vehicles = [Vehicle]()
    self.isShowingDeniedLocationAuthorizationAlert = false
    self.isShowingGloballyDeniedLocationAuthorizationAlert = false
    self.isShowingApiErrorAlert = nil

    self.setCenterExpectation = nil
  }

  // MARK: - View model

  func createViewModel() -> MapViewModel {
    let result = MapViewModel(store: self.store, environment: self.environment)
    result.setView(view: self)
    return result
  }

  func setCenter(location: CLLocationCoordinate2D, animated: Bool) {
    self.center = location

    if let e = self.setCenterExpectation {
      e.fulfill()
    }
  }

  func expectSetCenterCall() -> XCTestExpectation {
    let expectation = XCTestExpectation(description: "set-center")
    self.setCenterExpectation = expectation
    return expectation
  }

  func showVehicles(vehicles: [Vehicle]) {
    self.vehicles = vehicles
  }

  func showDeniedLocationAuthorizationAlert() {
    self.isShowingDeniedLocationAuthorizationAlert = true
  }

  func showGloballyDeniedLocationAuthorizationAlert() {
    self.isShowingGloballyDeniedLocationAuthorizationAlert = true
  }

  func showApiErrorAlert(error: ApiError) {
    self.isShowingApiErrorAlert = error
  }

  // MARK: - Set state

  func setAuthorization(_ value: UserLocationAuthorization) {
    self.setState { $0.userLocationAuthorization = value }
    self.userLocationManager.authorization = value
  }

  func setUserLocation(_ location: CLLocationCoordinate2D) {
    self.userLocationManager.current = .value(location)
  }

  func setUserLocation(error: Error) {
    self.userLocationManager.current = .init(error: error)
  }

  func setVehicleResponse(_ response: AppState.ApiResponseState<[Vehicle]>) {
    self.setState { $0.getVehicleLocationsResponse = response }
  }

  // MARK: - Dummy error

  class DummyError: Error, Equatable {
    static func == (lhs: MapViewModelTests.DummyError,
                    rhs: MapViewModelTests.DummyError) -> Bool {
      return lhs === rhs
    }
  }
}