//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct LineSelectionSectionFactory {

  static func convert(_ lines: [Line]) -> [LineSelectionSection] {
    return lines
      .groupedBy { $0.subtype }
      .map { LineSelectionSection(subtype: $0, lines: $1.sorted(by: .name)) }
      .sorted { getSubtypeOrder(for: $0.subtype) < getSubtypeOrder(for: $1.subtype) }
  }

  private static func getSubtypeOrder(for subtype: LineSubtype) -> Int {
    switch subtype {
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
