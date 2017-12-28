//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

private typealias Localization = Localizable.LineSelection.SectionName

typealias LineSelectionSection = RxSectionModel<LineSelectionSectionData, Line>

struct LineSelectionSectionData: Equatable {
  let lineSubtype: LineSubtype

  var lineSubtypeTranslation: String {
    switch self.lineSubtype {
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

  init(for lineSubtype: LineSubtype) {
    self.lineSubtype = lineSubtype
  }

  static func == (lhs: LineSelectionSectionData, rhs: LineSelectionSectionData) -> Bool {
    return lhs.lineSubtype == rhs.lineSubtype
  }
}
