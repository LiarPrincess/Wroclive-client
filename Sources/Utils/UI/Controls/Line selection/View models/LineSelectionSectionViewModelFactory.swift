//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct LineSelectionSectionViewModelFactory {

  static func convert(_ lines: [Line]) -> [LineSelectionSectionViewModel] {
    let viewModels = convertToViewModels(lines: lines)
    return sortViewModels(viewModels)
  }

  //MARK: - Convert

  private static func convertToViewModels(lines: [Line]) -> [LineSelectionSectionViewModel] {
    var linesBySubtype = [LineSubtype: [Line]]()

    for line in lines {
      if var lines = linesBySubtype[line.subtype] {
        lines.append(line)
        linesBySubtype[line.subtype] = lines
      }
      else {
        linesBySubtype[line.subtype] = [line]
      }
    }

    return linesBySubtype.map { (subtype, lines) in
      let linesSorted = sortLines(lines)
      return LineSelectionSectionViewModel(for: subtype, with: linesSorted)
    }
  }

  //MARK: - Sort

  private static func sortLines(_ lines: [Line]) -> [Line] {
    return lines.sorted { (lhs, rhs) in
      return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
    }
  }

  private static func sortViewModels(_ viewModels: [LineSelectionSectionViewModel]) -> [LineSelectionSectionViewModel] {
    return viewModels.sorted { (lhs, rhs) in
      return getSubtypeOrder(for: lhs.subtype) < getSubtypeOrder(for: rhs.subtype)
    }
  }

  private static func getSubtypeOrder(for subtype: LineSubtype) -> Int {
    switch subtype {
    case .express:   return 0
    case .regular:   return 1

    case .night:     return 2
    case .suburban:  return 3

    case .hour:      return 4
    case .zone:      return 5
    case .limited:   return 6
    case .temporary: return 7
    }
  }
}
