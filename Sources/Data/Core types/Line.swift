//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation

struct Line {
  let name: String
  let type: VehicleType
}

//MARK: - Equatable

extension Line: Equatable {
  static func ==(lhs: Line, rhs: Line) -> Bool {
    return lhs.type == rhs.type && lhs.name == rhs.name
  }
}

//MARK: - StringConvertible

extension Line: CustomStringConvertible {
  var description: String { return "(\(self.name), \(self.type))" }
}

extension Line: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}
