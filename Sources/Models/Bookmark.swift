//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct Bookmark: Codable {
  let name:  String
  let lines: [Line]
}

// MARK: Equatable

extension Bookmark: Equatable {
  static func == (lhs: Bookmark, rhs: Bookmark) -> Bool {
    return lhs.name  == rhs.name
        && lhs.lines == rhs.lines
  }
}
