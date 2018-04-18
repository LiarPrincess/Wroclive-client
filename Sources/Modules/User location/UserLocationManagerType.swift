//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

protocol UserLocationManagerType {

  /// Returns user location
  var current: Observable<CLLocationCoordinate2D> { get }

  /// Current authorization status
  var authorization: Observable<CLAuthorizationStatus> { get }

  /// Request when in use authorization
  func requestWhenInUseAuthorization()
}
