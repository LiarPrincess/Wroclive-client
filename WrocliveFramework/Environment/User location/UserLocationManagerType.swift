// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import MapKit
import PromiseKit

// We need 'AnyObject' to be able to set delegate.
public protocol UserLocationManagerType: AnyObject {

  var delegate: UserLocationManagerDelegate? { get set }

  /// Returns current user location.
  func getCurrent() -> Promise<CLLocationCoordinate2D>

  /// Current authorization status.
  func getAuthorizationStatus() -> UserLocationAuthorization

  /// Request when in use authorization.
  func requestWhenInUseAuthorization()
}
