//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

enum LineSelectionSectionCreator {

  static func create(_ lines: [Line]) -> [LineSelectionSection] {
    return lines
      .groupedBy { $0.subtype }
      .map { createSection(subtype: $0, lines: $1) }
      .sorted { getOrder(subtype: $0.model.lineSubtype) < getOrder(subtype: $1.model.lineSubtype) }
  }

  private static func createSection(subtype lineSubtype: LineSubtype, lines: [Line]) -> LineSelectionSection {
    let data = LineSelectionSectionData(for: lineSubtype)
    return LineSelectionSection(model: data, items: lines.sorted(by: .name))
  }

  private static func getOrder(subtype lineSubtype: LineSubtype) -> Int {
    switch lineSubtype {
    case .express:   return 0
    case .regular:   return 1

    case .night:     return 2
    case .suburban:  return 3

    case .peakHour:  return 4
    case .zone:      return 5
    case .limited:   return 6
    case .temporary: return 7
    }
  }
}
