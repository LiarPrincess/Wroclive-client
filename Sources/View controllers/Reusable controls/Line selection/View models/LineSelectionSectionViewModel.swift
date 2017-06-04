//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct LineSelectionSectionViewModel {
  let subtype:     LineSubtype
  let subtypeName: String

  let lines:          [Line]
  let lineViewModels: [LineSelectionCellViewModel]

  init(for subtype: LineSubtype, with lines: [Line]) {
    self.subtype     = subtype
    self.subtypeName = String(describing: subtype).capitalized

    self.lines          = lines
    self.lineViewModels = lines.map { LineSelectionCellViewModel(from: $0) }
  }
}
