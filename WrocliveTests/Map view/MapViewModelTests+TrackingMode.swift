// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
import WrocliveTestsShared
@testable import WrocliveFramework

private typealias Defaults = MapViewController.Constants.Default

extension MapViewModelTests {

  private var trackingModes: [MKUserTrackingMode] {
    return [.follow, .followWithHeading, .none]
  }

  // MARK: - Authorized

  func test_changingTrackingMode_whileAuthorized_doesNothing() {
    // 'doesNothing' means 'UIKit will handle this for us'.
    self.setAuthorization(.authorized)

    self.viewModel = self.createViewModel()
    XCTAssert(self.dispatchedActions.isEmpty)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.hasOpenedSettingsApp)

    for mode in self.trackingModes {
      self.viewModel.viewDidChangeTrackingMode(to: mode)
      XCTAssert(self.dispatchedActions.isEmpty)
      XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
      XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)
      XCTAssertFalse(self.hasOpenedSettingsApp)
    }
  }

  // MARK: - Not determined

  func test_changingTrackingMode_notDeterminedAuthorization_requestsAuthorization() {
    self.setAuthorization(.notDetermined)

    self.viewModel = self.createViewModel()
    XCTAssert(self.dispatchedActions.isEmpty)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.hasOpenedSettingsApp)

    for (index, mode) in self.trackingModes.enumerated() {
      self.viewModel.viewDidChangeTrackingMode(to: mode)

      XCTAssertEqual(self.dispatchedActions.count, index + 1)
      XCTAssert(self.isRequestWhenInUseAuthorizationAction(at: index))

      XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
      XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)
      XCTAssertFalse(self.hasOpenedSettingsApp)
    }

    // Dispatch action only, do not call manager
    let count = self.userLocationManager.requestWhenInUseAuthorizationCallCount
    XCTAssertEqual(count, 0)
  }

  // MARK: - Denied

  func test_changingTrackingMode_deniedAuthorization_showsDeniedAlert() {
    self.setAuthorization(.denied)

    self.viewModel = self.createViewModel()
    XCTAssert(self.dispatchedActions.isEmpty)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.hasOpenedSettingsApp)

    for mode in self.trackingModes {
      self.viewModel.viewDidChangeTrackingMode(to: mode)

      XCTAssertTrue(self.isShowingDeniedLocationAuthorizationAlert)
      XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)
      XCTAssertFalse(self.hasOpenedSettingsApp)
      self.isShowingDeniedLocationAuthorizationAlert = false // Reset

      self.viewModel.viewDidRequestOpenSettingsApp()
      XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
      XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)
      XCTAssertTrue(self.hasOpenedSettingsApp)
      self.hasOpenedSettingsApp = false // Reset
    }

    // No actions, just alert
    XCTAssertEqual(self.dispatchedActions.count, 0)
  }

  // MARK: - Restricted

  func test_changingTrackingMode_restrictedAuthorization_showsGloballyDeniedAlert() {
    self.setAuthorization(.restricted)

    self.viewModel = self.createViewModel()
    XCTAssert(self.dispatchedActions.isEmpty)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.hasOpenedSettingsApp)

    for mode in self.trackingModes {
      self.viewModel.viewDidChangeTrackingMode(to: mode)

      XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
      XCTAssertTrue(self.isShowingGloballyDeniedLocationAuthorizationAlert)
      XCTAssertFalse(self.hasOpenedSettingsApp)
      self.isShowingGloballyDeniedLocationAuthorizationAlert = false // Reset
    }

    // No actions, just alert
    XCTAssertEqual(self.dispatchedActions.count, 0)
  }
}
