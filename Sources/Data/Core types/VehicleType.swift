//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation

enum VehicleType: Int {
  case tram
  case bus
}

//MARK: - Equatable

extension VehicleType: Equatable {
  static func ==(lhs: VehicleType, rhs: VehicleType) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }
}

//MARK: - StringConvertible

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
