// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
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
   100 Get user location
   150 User location retrieved
   150 Center on user location
   */
  func test_launch_withAutorization_centersOnUserLocation() {
    let userLocation = CLLocationCoordinate2D(latitude: 5.0, longitude: 9.0)

    self.mockAuthorization(at: 0, .authorizedWhenInUse)
    self.mockViewDidAppear(at: 100)
    self.mockUserLocation(at: 100, Single.just(userLocation).delay(50, scheduler: self.scheduler))

    self.startScheduler()

    XCTAssertEqual(self.showAlertObserver.events, [])

    XCTAssertEqual(self.mapCenterObserver.events, [
      Recorded.next(0, Defaults.location),
      Recorded.next(150, userLocation)
    ])

    self.userLocationManager.assertOperationCount(currentLocation: 1, authorization: 1, requestWhenInUseAuthorization: 0)
  }

  /**
   Prerequisites:
   - Authorization: .authorizedWhenInUse

   Steps:
   0 Start with default map center
   100 View did appear
   100 Get user location
   150 User location error
   */
  func test_launch_withAutorization_locationError_centersOnDefault() {
    self.mockAuthorization(at: 0, .authorizedWhenInUse)
    self.mockViewDidAppear(at: 100)
    self.mockUserLocation(at: 100, Single.error(UserLocationError.generalError).delay(50, scheduler: self.scheduler))

    self.startScheduler()

    XCTAssertEqual(self.showAlertObserver.events, [])

    XCTAssertEqual(self.mapCenterObserver.events, [
      Recorded.next(0, Defaults.location)
    ])

    self.userLocationManager.assertOperationCount(currentLocation: 1, authorization: 1, requestWhenInUseAuthorization: 0)
  }

  /**
   Prerequisites:
   - Authorization: .denied

   Steps:
   0 Start with default map center
   100 View did appear
   */
  func test_launch_withDeniedAutorization_centersOnDefault() {
    self.mockAuthorization(at: 0, .denied)
    self.mockViewDidAppear(at: 100)

    self.startScheduler()

    XCTAssertEqual(self.showAlertObserver.events, [])

    XCTAssertEqual(self.mapCenterObserver.events, [
      Recorded.next(0, Defaults.location)
    ])

    self.userLocationManager.assertOperationCount(currentLocation: 0, authorization: 1, requestWhenInUseAuthorization: 0)
  }
}
