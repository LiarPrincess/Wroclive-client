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

private typealias Defaults = MapViewControllerConstants.Defaults

class MapViewModelFirstLaunchTests: MapViewModelTestsBase {

  func test_lauching_centersOnDefaultLocation() {
    self.testScheduler.start()
    XCTAssertEqual(self.mapCenterObserver.events, [next(0, Defaults.location)])
  }

  /**
   Prerequisites:
   - Authorization: .notDetermined

   Steps:
   0 Start with default map center
   100 View did appear
   102 Show authorization alert after delay
   200 User allows authorization
   300 User location retrieved
   300 Center on user location
   */
  func test_firstLaunch_grantingAutorization_centersOnUserLocation() {
    let userLocation = CLLocationCoordinate2D(latitude: 5.0, longitude: 9.0)

    self.mockAuthorizationEvents(AuthorizationEvent(0, .notDetermined))
    self.mockViewDidAppearEvent(at: 100)
    self.mockAuthorizationEvents(AuthorizationEvent(200, .authorizedWhenInUse))
    self.mockUserLocationEvents(UserLocationEvent(300, userLocation))

    self.testScheduler.start()

    let showAlertEvents = self.showAlertObserver.events
    let authorizationTime = (Int) (100 + AppEnvironment.variables.timings.locationAuthorizationPromptDelay)
    XCTAssertEqual(showAlertEvents, [next(authorizationTime, .requestLocationAuthorization)])

    let mapCenterEvents = self.mapCenterObserver.events
    XCTAssertEqual(mapCenterEvents, [next(0, Defaults.location), next(300, userLocation)])

    self.userLocationManager.assertOperationCount(current: 1, authorization: 1, requestWhenInUseAuthorization: 0)
  }

  /**
   Prerequisites:
   - Authorization: .notDetermined

   Steps:
   0 Start with default map center
   100 View did appear
   102 Show authorization alert after delay
   200 User allows authorization
   300 User location error
   */
  func test_firstLaunch_grantingAutorization_locationError_centersOnDefault() {
    self.mockAuthorizationEvents(AuthorizationEvent(0, .notDetermined))
    self.mockViewDidAppearEvent(at: 100)
    self.mockAuthorizationEvents(AuthorizationEvent(200, .authorizedWhenInUse))
    self.mockUserLocationError(UserLocationErrorEvent(300, .generalError))

    self.testScheduler.start()

    let showAlertEvents = self.showAlertObserver.events
    let authorizationTime = (Int) (100 + AppEnvironment.variables.timings.locationAuthorizationPromptDelay)
    XCTAssertEqual(showAlertEvents, [next(authorizationTime, .requestLocationAuthorization)])

    let mapCenterEvents = self.mapCenterObserver.events
    XCTAssertEqual(mapCenterEvents, [next(0, Defaults.location)])

    self.userLocationManager.assertOperationCount(current: 1, authorization: 1, requestWhenInUseAuthorization: 0)
  }

  /**
   Prerequisites:
   - Authorization: .notDetermined

   Steps:
   0 Start with default map center
   100 View did appear
   102 Show authorization alert after delay
   200 User denies authorization
   */
  func test_firstLaunch_denyingAutorization_centersOnDefault() {
    let userLocation = CLLocationCoordinate2D(latitude: 5.0, longitude: 9.0)

    self.mockAuthorizationEvents(AuthorizationEvent(0, .notDetermined))
    self.mockViewDidAppearEvent(at: 100)
    self.mockAuthorizationEvents(AuthorizationEvent(200, .denied))
    self.mockUserLocationEvents(UserLocationEvent(300, userLocation)) // should not be used

    self.testScheduler.start()

    let showAlertEvents = self.showAlertObserver.events
    let authorizationTime = (Int) (100 + AppEnvironment.variables.timings.locationAuthorizationPromptDelay)
    XCTAssertEqual(showAlertEvents, [next(authorizationTime, .requestLocationAuthorization)])

    let mapCenterEvents = self.mapCenterObserver.events
    XCTAssertEqual(mapCenterEvents, [next(0, Defaults.location)])

    self.userLocationManager.assertOperationCount(current: 0, authorization: 1, requestWhenInUseAuthorization: 0)
  }
}
