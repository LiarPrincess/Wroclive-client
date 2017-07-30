//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import MapKit

class VehicleLocation: NSObject {

  // MARK: - Properties

  let vehicleId: String
  let line:      Line
  let location:  CLLocationCoordinate2D
  let angle:     CLLocationDirection

  // MARK: - Init

  init(vehicleId: String, line: Line, location: CLLocationCoordinate2D, angle: CLLocationDirection) {
    self.vehicleId = vehicleId
    self.line      = line
    self.location  = location
    self.angle     = angle
  }
}

// MARK: - MKAnnotation

extension VehicleLocation: MKAnnotation {
  var coordinate: CLLocationCoordinate2D {
    return self.location
  }
}
