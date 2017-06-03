//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct LineSelectionSection {
  let type:    LineType
  let subtype: LineSubtype
  let lines:   [Line]

  init(_ type: LineType, _ subtype: LineSubtype, _ lines: [Line]) {
    self.type    = type
    self.subtype = subtype
    self.lines   = lines
  }
}
