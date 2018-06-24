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

class MapViewModelTrackingModeTests: MapViewModelTestsBase {

  /**
   Prerequisites:
   - Authorization: .notDetermined

   Steps:
   0 Start with default map center
   100 View did appear
   102 Show authorization alert after delay
   200 Change tracking to .follow
   300 Change tracking to .followWithHeading
   400 Change tracking to .none
   */
  func test_changingTrackingMode_withoutAutorization_requestsForAuthorization() {
    self.mockAuthorizationEvents(AuthorizationEvent(0, .notDetermined))
    self.mockViewDidAppearEvent(at: 100)
    self.mockTrackingModeChangedEvents(
      TrackingModeChangedEvent(200, .follow),
      TrackingModeChangedEvent(300, .followWithHeading),
      TrackingModeChangedEvent(400, .none)
    )

    self.testScheduler.start()

    let showAlertEvents = self.showAlertObserver.events
    let delayedDidAppear = (Int) (100 + AppEnvironment.current.variables.timings.locationAuthorizationPromptDelay)
    XCTAssertEqual(showAlertEvents, [
      Recorded.next(delayedDidAppear, .requestLocationAuthorization), // viewDidLoad also shows prompt, lets ignore it
      Recorded.next(200, .requestLocationAuthorization),
      Recorded.next(300, .requestLocationAuthorization),
      Recorded.next(400, .requestLocationAuthorization)
    ])

    self.userLocationManager.assertOperationCount(current: 0, authorization: 1, requestWhenInUseAuthorization: 0)
  }

  /**
   Prerequisites:
   - Authorization: .denied

   Steps:
   0 Start with default map center
   100 View did appear
   102 Show authorization alert after delay
   200 Change tracking to .follow
   300 Change tracking to .followWithHeading
   400 Change tracking to .none
   */
  func test_changingTrackingMode_withDeniedAuthorization_showsAuthorizationDeniedAlert() {
    self.mockAuthorizationEvents(AuthorizationEvent(0, .denied))
    self.mockViewDidAppearEvent(at: 100)
    self.mockTrackingModeChangedEvents(
      TrackingModeChangedEvent(200, .follow),
      TrackingModeChangedEvent(300, .followWithHeading),
      TrackingModeChangedEvent(400, .none)
    )

    self.testScheduler.start()

    XCTAssertEqual(self.showAlertObserver.events, [
      Recorded.next(200, .deniedLocationAuthorization),
      Recorded.next(300, .deniedLocationAuthorization),
      Recorded.next(400, .deniedLocationAuthorization)
    ])

    self.userLocationManager.assertOperationCount(current: 0, authorization: 1, requestWhenInUseAuthorization: 0)
  }

  /**
   Prerequisites:
   - Authorization: .restricted

   Steps:
   0 Start with default map center
   100 View did appear
   102 Show authorization alert after delay
   200 Change tracking to .follow
   300 Change tracking to .followWithHeading
   400 Change tracking to .none
   */
  func test_changingTrackingMode_withGloballyDeniedAuthorization_showsAuthorizationGloballyDeniedAlert() {
    self.mockAuthorizationEvents(AuthorizationEvent(0, .restricted))
    self.mockViewDidAppearEvent(at: 100)
    self.mockTrackingModeChangedEvents(
      TrackingModeChangedEvent(200, .follow),
      TrackingModeChangedEvent(300, .followWithHeading),
      TrackingModeChangedEvent(400, .none)
    )

    self.testScheduler.start()

    XCTAssertEqual(self.showAlertObserver.events, [
      Recorded.next(200, .globallyDeniedLocationAuthorization),
      Recorded.next(300, .globallyDeniedLocationAuthorization),
      Recorded.next(400, .globallyDeniedLocationAuthorization)
    ])

    self.userLocationManager.assertOperationCount(current: 0, authorization: 1, requestWhenInUseAuthorization: 0)
  }
}
