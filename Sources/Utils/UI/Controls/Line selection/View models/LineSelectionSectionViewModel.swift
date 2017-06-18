//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct LineSelectionSectionViewModel {
  let sectionName: String
  let subtype:     LineSubtype

  let lines:          [Line]
  let lineViewModels: [LineSelectionCellViewModel]

  init(for subtype: LineSubtype, with lines: [Line]) {
    self.subtype     = subtype
    self.sectionName = String(describing: subtype).capitalized

    self.lines          = lines
    self.lineViewModels = lines.map { LineSelectionCellViewModel(from: $0) }
  }
}
