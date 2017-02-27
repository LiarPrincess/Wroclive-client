//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import MapKit

//MARK: - LocationCoordinates

typealias LocationCoordinates = CLLocationCoordinate2D

extension LocationCoordinates: CustomStringConvertible {

  public var description: String { return "(\(format(self.latitude)), \(format(longitude)))" }

  private func format(_ value: CLLocationDegrees) -> String {
    return String(format: "%.2f", value)
  }
}

extension LocationCoordinates: CustomDebugStringConvertible {
  public var debugDescription: String { return self.description }
}

//MARK: - VechiclePosition

struct VehiclePosition {
  let line: Line
  let position: LocationCoordinates
}

extension VehiclePosition: CustomStringConvertible {
  var description: String { return "(\(self.line) at \(self.position))" }
}

extension VehiclePosition: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}
