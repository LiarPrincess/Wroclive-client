//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import MapKit

extension CLLocationCoordinate2D {
  func distance(from location: CLLocationCoordinate2D) -> CLLocationDistance {
    let lhs = CLLocation(coordinate: self)
    let rhs = CLLocation(coordinate: location)
    return lhs.distance(from: rhs)
  }
}
