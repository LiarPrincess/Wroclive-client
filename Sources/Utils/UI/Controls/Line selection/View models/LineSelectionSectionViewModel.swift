//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct LineSelectionSectionViewModel {
  let sectionName: String
  let subtype:     LineSubtype

  let lines:          [Line]
  let lineViewModels: [LineSelectionCellViewModel]

  init(for subtype: LineSubtype, lines: [Line]) {
    self.subtype     = subtype
    self.sectionName = String(describing: subtype).capitalized

    let sortedLines = lines.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }

    self.lines          = sortedLines
    self.lineViewModels = sortedLines.map { LineSelectionCellViewModel(from: $0) }
  }

}
