// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import RxSwift

protocol UserLocationManagerType: ManagerType {

  /// Returns user location
  var currentLocation: Single<CLLocationCoordinate2D> { get }

  /// Current authorization status
  var authorization: Observable<CLAuthorizationStatus> { get }

  /// Request when in use authorization
  func requestWhenInUseAuthorization()
}
