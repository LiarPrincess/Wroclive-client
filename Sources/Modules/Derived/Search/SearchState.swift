//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct SearchState: Codable {

  let selectedLineType: LineType
  let selectedLines:    [Line]

  init(withSelected lineType: LineType, lines: [Line]) {
    self.selectedLineType = lineType
    self.selectedLines    = lines
  }
}

// MARK: Equatable

extension SearchState: Equatable {
  static func == (lhs: SearchState, rhs: SearchState) -> Bool {
    return lhs.selectedLineType == rhs.selectedLineType
        && lhs.selectedLines    == rhs.selectedLines
  }
}
