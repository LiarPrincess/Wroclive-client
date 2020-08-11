// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
import PromiseKit
@testable import WrocliveFramework

class UserLocationManagerMock: UserLocationManagerType {

  private(set) var getCurrentCallCount = 0
  private(set) var getAuthorizationStatusCallCount = 0
  private(set) var requestWhenInUseAuthorizationCallCount = 0

  // MARK: - Current

  var current = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

  func getCurrent() -> Promise<CLLocationCoordinate2D> {
    self.getCurrentCallCount += 1
    return .value(self.current)
  }

  // MARK: - Authorization

  var authorization = UserLocationAuthorization.notDetermined

  func getAuthorizationStatus() -> UserLocationAuthorization {
    self.getAuthorizationStatusCallCount += 1
    return self.authorization
  }

  // MARK: - Request authorization

  func requestWhenInUseAuthorization() {
    self.requestWhenInUseAuthorizationCallCount += 1
  }
}
