//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit

protocol MapManager {

  /// Returns either: user location or city center
  func getDefaultRegion() -> Promise<MKCoordinateRegion>

  /// Current authorization status
  var authorizationStatus: CLAuthorizationStatus { get }

  /// Request authorization
  func requestInUseAuthorization()
}
