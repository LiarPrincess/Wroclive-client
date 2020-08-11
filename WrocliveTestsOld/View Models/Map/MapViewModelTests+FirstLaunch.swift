//// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//// If a copy of the MPL was not distributed with this file,
//// You can obtain one at http://mozilla.org/MPL/2.0/.
//
//import XCTest
//import MapKit
//import RxSwift
//import RxCocoa
//import RxTest
//@testable import Wroclive
//
//private typealias Defaults = MapViewControllerConstants.Defaults
//
//extension MapViewModelTests {
//
//  func test_lauching_centersOnDefaultLocation() {
//    self.startScheduler()
//    XCTAssertEqual(self.mapCenterObserver.events, [next(0, Defaults.location)])
//  }
//
//  /**
//   Prerequisites:
//   - Authorization: .notDetermined
//
//   Steps:
//   0 Start with default map center
//   100 View did appear
//   102 Show authorization alert after delay
//   200 User allows authorization
//   200 Get user location
//   250 User location retrieved
//   250 Center on user location
//   */
//  func test_firstLaunch_grantingAutorization_centersOnUserLocation() {
//    let userLocation = CLLocationCoordinate2D(latitude: 5.0, longitude: 9.0)
//    let delayedViewDidAppear = 100 + self.locationAuthorizationPromptDelay
//
//    self.mockAuthorization(at: 0, .notDetermined)
//    self.mockViewDidAppear(at: 100)
//    self.mockAuthorization(at: 200, .authorizedWhenInUse)
//    self.mockUserLocation(at: 200, Single.just(userLocation).delay(50, scheduler: self.scheduler))
//
//    self.startScheduler()
//
//    XCTAssertEqual(self.showAlertObserver.events, [
//      Recorded.next(delayedViewDidAppear, .requestLocationAuthorization)
//    ])
//
//    XCTAssertEqual(self.mapCenterObserver.events, [
//      Recorded.next(0, Defaults.location),
//      Recorded.next(250, userLocation)
//    ])
//
//    self.userLocationManager.assertOperationCount(currentLocation: 1, authorization: 1, requestWhenInUseAuthorization: 0)
//  }
//
//  /**
//   Prerequisites:
//   - Authorization: .notDetermined
//
//   Steps:
//   0 Start with default map center
//   100 View did appear
//   102 Show authorization alert after delay
//   200 User allows authorization
//   200 Get user location
//   250 User location error
//   */
//  func test_firstLaunch_grantingAutorization_locationError_centersOnDefault() {
//    let delayedViewDidAppear = 100 + self.locationAuthorizationPromptDelay
//
//    self.mockAuthorization(at: 0, .notDetermined)
//    self.mockViewDidAppear(at: 100)
//    self.mockAuthorization(at: 200, .authorizedWhenInUse)
//    self.mockUserLocation(at: 200, Single.error(UserLocationError.generalError))
//
//    self.startScheduler()
//
//    XCTAssertEqual(self.showAlertObserver.events, [
//      Recorded.next(delayedViewDidAppear, .requestLocationAuthorization)
//    ])
//
//    XCTAssertEqual(self.mapCenterObserver.events, [
//      Recorded.next(0, Defaults.location)
//    ])
//
//    self.userLocationManager.assertOperationCount(currentLocation: 1, authorization: 1, requestWhenInUseAuthorization: 0)
//  }
//
//  /**
//   Prerequisites:
//   - Authorization: .notDetermined
//
//   Steps:
//   0 Start with default map center
//   100 View did appear
//   102 Show authorization alert after delay
//   200 User denies authorization
//   */
//  func test_firstLaunch_denyingAutorization_centersOnDefault() {
//    let userLocation = CLLocationCoordinate2D(latitude: 5.0, longitude: 9.0)
//    let delayedViewDidAppear = 100 + self.locationAuthorizationPromptDelay
//
//    self.mockAuthorization(at: 0, .notDetermined)
//    self.mockViewDidAppear(at: 100)
//    self.mockAuthorization(at: 200, .denied)
//    self.mockUserLocation(at: 200, Single.just(userLocation)) // should not be used
//
//    self.startScheduler()
//
//    XCTAssertEqual(self.showAlertObserver.events, [
//      Recorded.next(delayedViewDidAppear, .requestLocationAuthorization)
//    ])
//
//    XCTAssertEqual(self.mapCenterObserver.events, [
//      Recorded.next(0, Defaults.location)
//    ])
//
//    self.userLocationManager.assertOperationCount(currentLocation: 0, authorization: 1, requestWhenInUseAuthorization: 0)
//  }
//}
