//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation

enum BusType: Int {
  case regular
  case express
  case hour
  case suburban
  case zone
  case limited
  case temporary
  case night
}

enum LineType {
  case tram
  case bus(BusType)
}

//MARK: - Equatable

extension LineType: Equatable {
  public static func ==(lhs: LineType, rhs: LineType) -> Bool {
    switch (lhs, rhs) {
    case (.tram, .tram):
      return true
    case let (.bus(lhsType), .bus(rhsType)):
      return lhsType == rhsType
    default:
      return false
    }
  }
}

//MARK: - StringConvertible

extension LineType: CustomStringConvertible {
  var description: String {
    switch self {
    case .tram: return "tram"
    case let .bus(type):  return "\(type) bus"
    }
  }
}

extension LineType: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}
