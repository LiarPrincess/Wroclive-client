//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class VehicleLocation: NSObject {

  // MARK: - Properties

  let vehicleId: String
  let line:      Line

  let latitude:  Double
  let longitude: Double
  let angle:     Double

  // MARK: - Init

  init(vehicleId: String, line: Line, latitude: Double, longitude: Double, angle: Double) {
    self.vehicleId = vehicleId
    self.line      = line
    self.latitude  = latitude
    self.longitude = longitude
    self.angle     = angle
  }
}
