//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import MapKit

class VehicleLocation: NSObject {

  // MARK: - Properties

  let line:     Line
  let location: CLLocationCoordinate2D
  let angle:    CLLocationDirection

  // MARK: - init

  init(line: Line, location: CLLocationCoordinate2D, angle: CLLocationDirection) {
    self.line     = line
    self.location = location
    self.angle    = angle
  }
}

// MARK: - MKAnnotation

extension VehicleLocation: MKAnnotation {
  var coordinate: CLLocationCoordinate2D {
    return self.location
  }
}
