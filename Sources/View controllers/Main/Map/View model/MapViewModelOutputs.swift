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
   Scenarios:
   1. from manager
   */
  var mapType: Driver<MKMapType> { get }

  /**
   Scenarios:
   1. user opened app -> view shown -> is authorized
   2. user opened app -> user changed location authorization -> from not determined -> is authorized

   Start with: default
   */
  var mapCenter: Driver<CLLocationCoordinate2D> { get }

  /**
   Scenarios:
   1. vehicles from manager -> filter data
   */
  var vehicleLocations: Driver<[Vehicle]> { get }

  /**
   Scenarios:
   1. user opened app -> view shown -> not determined authorization
   2. user changed tracking -> not determined authorization
   */
  var showLocationAuthorizationAlert: Driver<Void> { get }

  /**
   Scenarios:
   1. user changed tracking -> denied authorization
   */
  var showDeniedLocationAuthorizationAlert: Driver<DeniedLocationAuthorizationAlert> { get }

  /**
   Scenarios:
   1. vehicles from manager -> filter errors
   */
  var showApiErrorAlert: Driver<ApiError> { get }
}
