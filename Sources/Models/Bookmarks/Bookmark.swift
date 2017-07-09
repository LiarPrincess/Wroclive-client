//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

struct Bookmark {
  let id:    String
  let name:  String
  let lines: [BookmarkLine]
  let order: Int
}

// MARK: - Equatable

extension Bookmark: Equatable {
  static func == (lhs: Bookmark, rhs: Bookmark) -> Bool {
    return lhs.id == rhs.id
  }
}

// MARK: - StringConvertible

extension Bookmark: CustomStringConvertible {
  var description: String { return "(\(self.name), \(self.lines))" }
}

extension Bookmark: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}
