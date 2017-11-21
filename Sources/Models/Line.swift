//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct Line: Codable {
  let name:    String
  let type:    LineType
  let subtype: LineSubtype
}

// MARK: Equatable

extension Line: Equatable {
  static func == (lhs: Line, rhs: Line) -> Bool {
    return lhs.name    == rhs.name
        && lhs.type    == rhs.type
        && lhs.subtype == rhs.subtype
  }
}
