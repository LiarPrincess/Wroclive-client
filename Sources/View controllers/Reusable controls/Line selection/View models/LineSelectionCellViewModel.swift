//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct LineSelectionCellViewModel {
  let line:     Line
  let lineName: String

  init(from line: Line) {
    self.line     = line
    self.lineName = line.name
  }
}
