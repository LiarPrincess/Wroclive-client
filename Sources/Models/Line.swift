//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation

struct Line {
  let name: String
  let type: LineType
}

//MARK: - Equatable

extension Line: Equatable {
  static func ==(lhs: Line, rhs: Line) -> Bool {
    return lhs.name == rhs.name && lhs.type == rhs.type
  }
}

//MARK: - StringConvertible

extension Line: CustomStringConvertible {
  var description: String { return "(\(self.name), \(self.type))" }
}

extension Line: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}
