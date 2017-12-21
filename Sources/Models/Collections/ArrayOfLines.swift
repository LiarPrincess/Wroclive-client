//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

enum LineArraySortType {
  case name
}

extension Array where Element == Line {

  func filter(_ type: LineType) -> [Line] {
    return self.filter { $0.type == type }
  }

  func sorted(by type: LineArraySortType) -> [Line] {
    switch type {
    case .name: return self.sorted(by: nameComparer)
    }
  }

  private func nameComparer(lhs: Line, rhs: Line) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
  }
}
