//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

private typealias Localization = Localizable.Controls.LineSelection

struct LineSelectionSectionViewModel {
  let sectionName: String
  let subtype:     LineSubtype

  let lines:          [Line]
  let lineViewModels: [LineSelectionCellViewModel]

  init(for subtype: LineSubtype, lines: [Line]) {
    self.subtype     = subtype
    self.sectionName = LineSelectionSectionViewModel.createSectionName(subtype: subtype)

    let sortedLines     = lines.sortedByName()
    self.lines          = sortedLines
    self.lineViewModels = sortedLines.map { LineSelectionCellViewModel(from: $0) }
  }

  private static func createSectionName(subtype: LineSubtype) -> String {
    switch subtype {
    case .regular:   return Localization.regular
    case .express:   return Localization.express
    case .peakHour:  return Localization.peakHour
    case .suburban:  return Localization.suburban
    case .zone:      return Localization.zone
    case .limited:   return Localization.limited
    case .temporary: return Localization.temporary
    case .night:     return Localization.night
    }
  }
}
