//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import MapKit

struct LocationManagerConstants {

  struct Tracking {
    static let distanceFilter: CLLocationDistance = 5.0
    static let accuracy:       CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters
  }

  struct Default {
    static let location   = CLLocationCoordinate2D(latitude: 51.109524, longitude: 17.032564)
    static let regionSize = CLLocationDistance(2500.0)
  }
}
