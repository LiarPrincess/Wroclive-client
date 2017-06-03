//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

enum LineType: Int {
  case tram
  case bus
}

//MARK: - StringConvertible

extension LineType: CustomStringConvertible {
  var description: String {
    switch self {
    case .tram: return "tram"
    case .bus:  return "bus"
    }
  }
}

extension LineType: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}
