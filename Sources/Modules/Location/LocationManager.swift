//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit

protocol LocationManager {

  /// Returns user location
  func getCurrent() -> Promise<CLLocationCoordinate2D>

  /// Current authorization status
  var authorization: CLAuthorizationStatus { get }

  /// Request authorization
  func requestAuthorization()
}
