//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation

//MARK: - LineSelectionSection

struct LineSelectionSection {
  let lineType:    LineType
  let lineSubtype: LineSubtype
  let lines:       [Line]

  init(_ type: LineType, _ subtype: LineSubtype, _ lines: [Line]) {
    self.lineType = type
    self.lineSubtype = subtype
    self.lines = lines
  }
}
