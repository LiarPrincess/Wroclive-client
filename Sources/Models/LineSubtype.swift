//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

enum LineSubtype: Int {
  case regular
  case express
  case hour
  case suburban
  case zone
  case limited
  case temporary
  case night
}

//MARK: - StringConvertible

extension LineSubtype: CustomStringConvertible {
  var description: String {
    switch self {
    case .regular:   return "regular"
    case .express:   return "express"
    case .hour:      return "hour"
    case .suburban:  return "suburban"
    case .zone:      return "zone"
    case .limited:   return "limited"
    case .temporary: return "temporary"
    case .night:     return "night"
    }
  }
}

extension LineSubtype: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}
