//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit

protocol LocationManager {

  /// Returns either: user location or city center
  func getCenter() -> MKCoordinateRegion

  /// Current authorization status
  var authorizationStatus: CLAuthorizationStatus { get }

  /// Request authorization
  func requestInUseAuthorization()
}
