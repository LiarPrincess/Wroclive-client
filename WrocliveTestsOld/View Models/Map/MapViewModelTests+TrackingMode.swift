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
//  /**
//   Prerequisites:
//   - Authorization: .notDetermined
//
//   Steps:
//   0 Start with default map center
//   100 View did appear
//   102 Show authorization alert after delay
//   200 Change tracking to .follow
//   300 Change tracking to .followWithHeading
//   400 Change tracking to .none
//   */
//  func test_changingTrackingMode_withoutAutorization_requestsForAuthorization() {
//    let delayedViewDidAppear = 100 + self.locationAuthorizationPromptDelay
//
//    self.mockAuthorization(at: 0, .notDetermined)
//    self.mockViewDidAppear(at: 100)
//    self.mockTrackingModeChange(at: 200, .follow)
//    self.mockTrackingModeChange(at: 300, .followWithHeading)
//    self.mockTrackingModeChange(at: 400, .none)
//
//    self.startScheduler()
//
//    XCTAssertEqual(self.showAlertObserver.events, [
//      Recorded.next(delayedViewDidAppear, .requestLocationAuthorization), // viewDidLoad also shows prompt, lets ignore it
//      Recorded.next(200, .requestLocationAuthorization),
//      Recorded.next(300, .requestLocationAuthorization),
//      Recorded.next(400, .requestLocationAuthorization)
//    ])
//
//    self.userLocationManager.assertOperationCount(currentLocation: 0, authorization: 1, requestWhenInUseAuthorization: 0)
//  }
//
//  /**
//   Prerequisites:
//   - Authorization: .denied
//
//   Steps:
//   0 Start with default map center
//   100 View did appear
//   102 Show authorization alert after delay
//   200 Change tracking to .follow
//   300 Change tracking to .followWithHeading
//   400 Change tracking to .none
//   */
//  func test_changingTrackingMode_withDeniedAuthorization_showsAuthorizationDeniedAlert() {
//    self.mockAuthorization(at: 0, .denied)
//    self.mockViewDidAppear(at: 100)
//    self.mockTrackingModeChange(at: 200, .follow)
//    self.mockTrackingModeChange(at: 300, .followWithHeading)
//    self.mockTrackingModeChange(at: 400, .none)
//
//    self.startScheduler()
//
//    XCTAssertEqual(self.showAlertObserver.events, [
//      Recorded.next(200, .deniedLocationAuthorization),
//      Recorded.next(300, .deniedLocationAuthorization),
//      Recorded.next(400, .deniedLocationAuthorization)
//    ])
//
//    self.userLocationManager.assertOperationCount(currentLocation: 0, authorization: 1, requestWhenInUseAuthorization: 0)
//  }
//
//  /**
//   Prerequisites:
//   - Authorization: .restricted
//
//   Steps:
//   0 Start with default map center
//   100 View did appear
//   102 Show authorization alert after delay
//   200 Change tracking to .follow
//   300 Change tracking to .followWithHeading
//   400 Change tracking to .none
//   */
//  func test_changingTrackingMode_withGloballyDeniedAuthorization_showsAuthorizationGloballyDeniedAlert() {
//    self.mockAuthorization(at: 0, .restricted)
//    self.mockViewDidAppear(at: 100)
//    self.mockTrackingModeChange(at: 200, .follow)
//    self.mockTrackingModeChange(at: 300, .followWithHeading)
//    self.mockTrackingModeChange(at: 400, .none)
//
//    self.startScheduler()
//
//    XCTAssertEqual(self.showAlertObserver.events, [
//      Recorded.next(200, .globallyDeniedLocationAuthorization),
//      Recorded.next(300, .globallyDeniedLocationAuthorization),
//      Recorded.next(400, .globallyDeniedLocationAuthorization)
//    ])
//
//    self.userLocationManager.assertOperationCount(currentLocation: 0, authorization: 1, requestWhenInUseAuthorization: 0)
//  }
//}
