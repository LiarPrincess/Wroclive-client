//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

protocol MapViewModelOutputs {

  /**
   - from manager
   */
  var mapType: Driver<MKMapType> { get }

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
