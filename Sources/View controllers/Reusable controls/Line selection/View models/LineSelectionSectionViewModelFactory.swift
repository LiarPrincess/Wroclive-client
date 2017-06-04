//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct LineSelectionSectionViewModelFactory {

  static func create(from lines: [Line]) -> [LineSelectionSectionViewModel] {
    let viewModels = self.convertToViewModels(lines: lines)
    return self.sort(viewModels: viewModels)
  }

  //MARK: - Convert

  private static func convertToViewModels(lines: [Line]) -> [LineSelectionSectionViewModel] {
    var linesBySubtype = [LineSubtype: [Line]]()

    for line in lines {
      if let _ = linesBySubtype[line.subtype] {
        linesBySubtype[line.subtype]!.append(line)
      }
      else {
        linesBySubtype[line.subtype] = [line]
      }
    }

    return linesBySubtype.map { return LineSelectionSectionViewModel(for: $0, with: self.sort(lines: $1)) }
  }

  //MARK: - Sort

  fileprivate static func sort(lines: [Line]) -> [Line] {
    return lines.sorted { (lhs, rhs) in
      let lhsInt = Int(lhs.name)
      let rhsInt = Int(rhs.name)

      // both numbers
      if let lhsNum = lhsInt, let rhsNum = rhsInt {
        return lhsNum < rhsNum
      }

      // one is number
      if let _ = lhsInt {
        return true
      }

      if let _ = rhsInt {
        return false
      }

      // none is number
      return lhs.name.caseInsensitiveCompare(rhs.name) == .orderedAscending
    }
  }

  private static func sort(viewModels: [LineSelectionSectionViewModel]) -> [LineSelectionSectionViewModel] {
    return viewModels.sorted { (lhs, rhs) in
      return order(for: lhs.subtype) < self.order(for: rhs.subtype)
    }
  }

  private static func order(for subtype: LineSubtype) -> Int {
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
