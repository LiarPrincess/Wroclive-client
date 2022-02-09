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

  // MARK: - Not determined

  // 'notDetermined' means 1st launch - it is in a different file

  // MARK: - Authorized

  /// Prerequisites:
  /// - Authorization: .authorizedWhenInUse
  ///
  /// Steps:
  /// 0. Start with default map center
  /// 1. Get user location
  /// 2. Center on user location
  func test_launch_withAutorization_centersOnUserLocation() throws {
    self.setAuthorization(.authorized)
    self.setUserLocation(userLocation)

    self.viewModel = self.createViewModel()
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    let expectation = self.expectSetCenterCall()
    self.wait(for: [expectation], timeout: halfSecond)

    XCTAssertEqual(self.center, userLocation)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    XCTAssertEqual(self.userLocationManager.getCurrentCallCount, 1)
  }

  /// Prerequisites:
  /// - Authorization: .authorizedWhenInUse
  ///
  /// Steps:
  /// 0. Start with default map center
  /// 1. Get user location
  /// 2. User location error -> stay on default center
  func test_launch_withAutorization_locationError_centersOnDefault_andIgnoresError() {
    self.setAuthorization(.authorized)
    self.setUserLocation(error: DummyError())

    self.viewModel = self.createViewModel()
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    let expectation = self.expectSetCenterCall()
    expectation.isInverted = true // We do NOT want to be called
    self.wait(for: [expectation], timeout: halfSecond)

    // No changes here
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    XCTAssertEqual(self.userLocationManager.getCurrentCallCount, 1)
  }

  // MARK: - Denied

  /// Prerequisites:
  /// - Authorization: .denied
  ///
  /// Steps:
  /// 1. Start with default map center
  /// 2. Do NOT call 'setCenter' again
  /// 3. Do NOT call 'self.userLocationManager.getCurrent()'
  func test_launch_withDeniedAutorization_centersOnDefault() {
    self.setAuthorization(.denied)

    self.viewModel = self.createViewModel()
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    let expectation = self.expectSetCenterCall()
    expectation.isInverted = true // We do NOT want to be called
    self.wait(for: [expectation], timeout: halfSecond)

    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    XCTAssertEqual(self.userLocationManager.getCurrentCallCount, 0)
  }

  // MARK: - Restricted

  /// Prerequisites:
  /// - Authorization: .restricted
  ///
  /// Steps:
  /// 1. Start with default map center
  /// 2. Do NOT call 'setCenter' again
  /// 3. Do NOT call 'self.userLocationManager.getCurrent()'
  func test_launch_withRestrictedAutorization_centersOnDefault() {
    self.setAuthorization(.restricted)

    self.viewModel = self.createViewModel()
    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    let expectation = self.expectSetCenterCall()
    expectation.isInverted = true // We do NOT want to be called
    self.wait(for: [expectation], timeout: halfSecond)

    XCTAssertEqual(self.center, defaultCenter)
    XCTAssertFalse(self.isShowingDeniedLocationAuthorizationAlert)
    XCTAssertFalse(self.isShowingGloballyDeniedLocationAuthorizationAlert)

    XCTAssertEqual(self.userLocationManager.getCurrentCallCount, 0)
  }
}
