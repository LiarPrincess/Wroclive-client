// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import RxSwift
import RxCocoa

protocol MapViewModelOutputs {

  /**
   - view shown -> is authorized
   - changed authorization -> from not determined -> is authorized
   default: city center
   */
  var mapCenter: Driver<CLLocationCoordinate2D> { get }

  /**
   - from manager -> filter values
   */
  var vehicleLocations: Driver<[Vehicle]> { get }

  /**
   - view shown -> not determined authorization
   - changed tracking mode -> not determined authorization
   */
  var showLocationAuthorizationAlert: Driver<Void> { get }

  /**
   - changed tracking mode -> denied authorization
   */
  var showDeniedLocationAuthorizationAlert: Driver<DeniedLocationAuthorizationAlert> { get }

  /**
   - vehicles from manager -> filter errors
   */
  var showApiErrorAlert: Driver<ApiError> { get }
}
