//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class Vehicle: NSObject {

  // MARK: - Properties

  let id:   String
  let line: Line

  let latitude:  Double
  let longitude: Double
  let angle:     Double

  // MARK: - Init

  init(id: String, line: Line, latitude: Double, longitude: Double, angle: Double) {
    self.id        = id
    self.line      = line
    self.latitude  = latitude
    self.longitude = longitude
    self.angle     = angle
  }
}
