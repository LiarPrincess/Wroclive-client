// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import MapKit
import PromiseKit
@testable import WrocliveFramework

public class UserLocationManagerMock: UserLocationManagerType {

  public private(set) var getCurrentCallCount = 0
  public private(set) var getAuthorizationStatusCallCount = 0
  public private(set) var requestWhenInUseAuthorizationCallCount = 0

  // MARK: - Current

  public var current = Promise<CLLocationCoordinate2D>.value(CLLocationCoordinate2D())

  public func getCurrent() -> Promise<CLLocationCoordinate2D> {
    self.getCurrentCallCount += 1
    return self.current
  }

  // MARK: - Authorization

  public var authorization = UserLocationAuthorization.notDetermined

  public func getAuthorizationStatus() -> UserLocationAuthorization {
    self.getAuthorizationStatusCallCount += 1
    return self.authorization
  }

  // MARK: - Request authorization

  public func requestWhenInUseAuthorization() {
    self.requestWhenInUseAuthorizationCallCount += 1
  }
}
