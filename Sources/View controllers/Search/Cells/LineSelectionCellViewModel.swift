//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct LineSelectionCellViewModel {
  let lineName: String

  init(from line: Line) {
    self.lineName = line.name
  }
}
