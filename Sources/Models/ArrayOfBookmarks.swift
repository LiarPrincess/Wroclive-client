//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

extension Array where Element == Bookmark {

  func sortByName() -> [Bookmark] {
    return self.sorted { (lhs: Bookmark, rhs: Bookmark) in
      lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
    }
  }
}
