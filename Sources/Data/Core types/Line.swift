//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import MapKit

//MARK: - VehicleType

enum VehicleType: Int {
  case tram
  case bus
}

extension VehicleType: CustomStringConvertible {
  var description: String {
    switch self {
    case .tram:
      return "tram"

    case .bus:
      return "bus"
    }
  }
}

extension VehicleType: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}

//MARK: - Line

struct Line {
  let name: String
  let type: VehicleType
}

extension Line: CustomStringConvertible {
  var description: String { return "(\(self.name), \(self.type))" }
}

extension Line: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}
