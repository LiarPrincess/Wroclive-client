//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct LineSelectionCellViewModel {
  let line:     Line
  var lineName: String { return self.line.name.uppercased() }

  let theme: ThemeManager

  init(from line: Line, theme: ThemeManager) {
    self.line  = line
    self.theme = theme
  }
}
