// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
import WrocliveTestsShared
@testable import WrocliveFramework

private let halfSecond = TimeInterval(0.5)
private let defaultCenter = MapViewController.Constants.Default.center
private let userLocation = CLLocationCoordinate2D(latitude: 5.0, longitude: 9.0)

extension MapViewModelTests {

  // MARK: - Center by default

  func test_lauching_centersOnDefaultLocation() {
    self.viewModel = self.createViewModel()
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)
  }

  // MARK: - Still not determined

  /// Prerequisites:
  /// - Authorization: .notDetermined
  ///
  /// Steps:
  /// 1. Start with default map center
  /// (Show authorization alert - view model is not responible for this)
  /// 2. User ignores authorization alert
  func test_firstLaunch_stillNotDeterminedAutorization_doesNothing() {
    self.setAuthorization(.notDetermined)

    self.viewModel = self.createViewModel()
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    let expectation = self.expectSetCenterCall()
    expectation.isInverted = true // We do NOT want to be called
    self.setAuthorization(.notDetermined)
    self.wait(for: [expectation], timeout: halfSecond)

    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    XCTAssertEqual(self.userLocationManager.getCurrentCallCount, 0)
  }

  // MARK: - Granting authorization

  /// Prerequisites:
  /// - Authorization: .notDetermined
  ///
  /// Steps:
  /// 1. Start with default map center
  /// (Show authorization alert - view model is not responible for this)
  /// 2. User allows authorization
  /// 3. Get user location
  /// 4. Center on user location
  func test_firstLaunch_grantingAutorization_centersOnUserLocation() {
    self.setAuthorization(.notDetermined)
    self.setUserLocation(userLocation)

    self.viewModel = self.createViewModel()
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    let expectation = self.expectSetCenterCall()
    self.setAuthorization(.authorized)
    self.wait(for: [expectation], timeout: halfSecond)

    XCTAssertEqual(self.center, userLocation)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    XCTAssertEqual(self.userLocationManager.getCurrentCallCount, 1)
  }

  /// Prerequisites:
  /// - Authorization: .notDetermined
  ///
  /// Steps:
  /// 1 Start with default map center
  /// (Show authorization alert - view model is not responible for this)
  /// 2. User allows authorization
  /// 3. Get user location - error
  /// 4. Stay in default center
  func test_firstLaunch_grantingAutorization_locationError_centersOnDefault_andIgnoresError() {
    self.setAuthorization(.notDetermined)
    self.setUserLocation(error: DummyError())

    self.viewModel = self.createViewModel()
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    let expectation = self.expectSetCenterCall()
    expectation.isInverted = true // We do NOT want to be called
    self.setAuthorization(.authorized)
    self.wait(for: [expectation], timeout: halfSecond)

    // No changes here
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    XCTAssertEqual(self.userLocationManager.getCurrentCallCount, 1)
  }

   // MARK: - Denying autorization

  /// Prerequisites:
  /// - Authorization: .notDetermined
  ///
  /// Steps:
  /// 1. Start with default map center
  /// (Show authorization alert - view model is not responible for this)
  /// 2. User denies authorization
  /// 3. Stay in default center
  func test_firstLaunch_denyingAutorization_centersOnDefault() {
    self.setAuthorization(.notDetermined)

    self.viewModel = self.createViewModel()
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    let expectation = self.expectSetCenterCall()
    expectation.isInverted = true // We do NOT want to be called
    self.setAuthorization(.denied)
    self.wait(for: [expectation], timeout: halfSecond)

    // No changes here
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    XCTAssertEqual(self.userLocationManager.getCurrentCallCount, 0)
  }

   // MARK: - Restricted autorization

  /// Prerequisites:
  /// - Authorization: .restricted
  ///
  /// Steps:
  /// 1. Start with default map center
  /// (Show authorization alert - view model is not responible for this)
  /// 2. User denies authorization
  /// 3. Stay in default center
  func test_firstLaunch_restrictedAutorization_centersOnDefault() {
    self.setAuthorization(.notDetermined)

    self.viewModel = self.createViewModel()
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    let expectation = self.expectSetCenterCall()
    expectation.isInverted = true // We do NOT want to be called
    self.setAuthorization(.restricted)
    self.wait(for: [expectation], timeout: halfSecond)

    // No changes here
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    XCTAssertEqual(self.userLocationManager.getCurrentCallCount, 0)
  }
}
