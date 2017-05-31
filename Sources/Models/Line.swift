//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import Foundation

struct Line {
  let name:    String
  let type:    LineType
  let subtype: LineSubtype
}

//MARK: - Equatable

extension Line: Equatable {
  static func ==(lhs: Line, rhs: Line) -> Bool {
    return lhs.name    == rhs.name
        && lhs.type    == rhs.type
        && lhs.subtype == rhs.subtype
  }
}

//MARK: - StringConvertible

extension Line: CustomStringConvertible {
  var description: String { return "(\(self.name), \(self.subtype) \(self.type))" }
}

extension Line: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}
