//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct SearchCardState: Codable {

  let page:          LineType
  let selectedLines: [Line]

  init(page: LineType, selectedLines: [Line]) {
    self.page          = page
    self.selectedLines = selectedLines
  }
}

// MARK: Equatable

extension SearchCardState: Equatable {
  static func == (lhs: SearchCardState, rhs: SearchCardState) -> Bool {
    return lhs.page == rhs.page
        && lhs.selectedLines == rhs.selectedLines
  }
}
