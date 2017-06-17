//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct LineSelectionCellViewModel {
  let line:     Line
  var lineName: String { return self.line.name }

  init(from line: Line) {
    self.line = line
  }
}
