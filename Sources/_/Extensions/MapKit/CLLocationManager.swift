//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationManager {
  var authorizationStatus: CLAuthorizationStatus { return CLLocationManager.authorizationStatus() }
}

