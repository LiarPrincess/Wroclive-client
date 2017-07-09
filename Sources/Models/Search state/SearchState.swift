//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

/// SearchViewController state
struct SearchState {
  let selectedLineType: LineType
  let selectedLines:    [Line]

  init(withSelected lineType: LineType, lines: [Line]) {
    self.selectedLineType = lineType
    self.selectedLines    = lines
  }
}
