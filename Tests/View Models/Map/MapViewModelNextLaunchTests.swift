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

class MapViewModelNextLaunchTests: MapViewModelTestsBase {

  /**
   Prerequisites:
   - Authorization: .authorizedWhenInUse

   Steps:
   0 Start with default map center
   100 View did appear
   200 User location retrieved
   200 Center on user location
   */
  func test_launch_withAutorization_centersOnUserLocation() {
    let userLocation = CLLocationCoordinate2D(latitude: 5.0, longitude: 9.0)

    self.mockAuthorizationEvents(AuthorizationEvent(0, .authorizedWhenInUse))
    self.mockViewDidAppearEvent(at: 100)
    self.mockUserLocationEvents(UserLocationEvent(200, userLocation))

    self.startScheduler()

    let showAlertEvents = self.showAlertObserver.events
    XCTAssertEqual(showAlertEvents, [])

    let mapCenterEvents = self.mapCenterObserver.events
    XCTAssertEqual(mapCenterEvents, [next(0, Defaults.location), next(200, userLocation)])

    self.userLocationManager.assertOperationCount(current: 1, authorization: 1, requestWhenInUseAuthorization: 0)
  }

  /**
   Prerequisites:
   - Authorization: .authorizedWhenInUse

   Steps:
   0 Start with default map center
   100 View did appear
   200 User location error
   */
  func test_launch_withAutorization_locationError_centersOnDefault() {
    self.mockAuthorizationEvents(AuthorizationEvent(0, .authorizedWhenInUse))
    self.mockViewDidAppearEvent(at: 100)
    self.mockUserLocationError(UserLocationErrorEvent(200, .generalError))

    self.startScheduler()

    let showAlertEvents = self.showAlertObserver.events
    XCTAssertEqual(showAlertEvents, [])

    let mapCenterEvents = self.mapCenterObserver.events
    XCTAssertEqual(mapCenterEvents, [next(0, Defaults.location)])

    self.userLocationManager.assertOperationCount(current: 1, authorization: 1, requestWhenInUseAuthorization: 0)
  }

  /**
   Prerequisites:
   - Authorization: .denied

   Steps:
   0 Start with default map center
   100 View did appear
   */
  func test_launch_withDeniedAutorization_centersOnDefault() {
    self.mockAuthorizationEvents(AuthorizationEvent(0, .denied))
    self.mockViewDidAppearEvent(at: 100)

    self.startScheduler()

    let showAlertEvents = self.showAlertObserver.events
    XCTAssertEqual(showAlertEvents, [])

    let mapCenterEvents = self.mapCenterObserver.events
    XCTAssertEqual(mapCenterEvents, [next(0, Defaults.location)])

    self.userLocationManager.assertOperationCount(current: 0, authorization: 1, requestWhenInUseAuthorization: 0)
  }
}
