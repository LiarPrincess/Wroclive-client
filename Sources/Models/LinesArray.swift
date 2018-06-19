//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

extension Array where Element == Line {
  func filter(_ type: LineType) -> [Line] {
    return self.filter { $0.type == type }
  }

  func sortedByName() -> [Line] {
    return self.sorted { lhs, rhs in lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending }
  }
}
