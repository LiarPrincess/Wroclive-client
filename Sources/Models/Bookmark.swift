//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import Foundation

struct Bookmark {
  let name:  String
  let lines: [Line]
}

//MARK: - Equatable

extension Bookmark: Equatable {
  static func ==(lhs: Bookmark, rhs: Bookmark) -> Bool {
    return lhs.name  == rhs.name
        && lhs.lines == rhs.lines
  }
}

//MARK: - StringConvertible

extension Bookmark: CustomStringConvertible {
  var description: String { return "(\(self.name), \(self.lines))" }
}

extension Bookmark: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}
