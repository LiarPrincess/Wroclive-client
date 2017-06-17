//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct SearchViewControllerState {
  let lineTypeFilter: LineType
  let selectedLines:  [Line]

  init(filter lineTypeFilter: LineType, selectedLines: [Line]) {
    self.lineTypeFilter = lineTypeFilter
    self.selectedLines  = selectedLines
  }
}
