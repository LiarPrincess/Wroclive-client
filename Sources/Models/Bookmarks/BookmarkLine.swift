//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct BookmarkLine {
  let id:      Int
  let name:    String
  let type:    LineType
  let subtype: LineSubtype
}

// MARK: - Equatable

extension BookmarkLine: Equatable {
  static func == (lhs: BookmarkLine, rhs: BookmarkLine) -> Bool {
    return lhs.id == rhs.id
  }
}

// MARK: - StringConvertible

extension BookmarkLine: CustomStringConvertible {
  var description: String { return "(\(self.name), \(self.subtype) \(self.type))" }
}

extension BookmarkLine: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}
