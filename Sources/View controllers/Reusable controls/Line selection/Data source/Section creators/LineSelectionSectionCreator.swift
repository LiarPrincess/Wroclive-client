//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

class LineSelectionSectionCreator: LineSelectionSectionCreatorProtocol {

  func create(from lines:[Line]) -> [LineSelectionSection] {
    let sections = self.convertToSections(lines: lines)
    return self.sort(sections: sections)
  }

  //MARK: - Convert

  private struct SectionId: Equatable, Hashable {
    let lineType:    LineType
    let lineSubtype: LineSubtype

    public var hashValue: Int {
      return 1000 * self.lineType.rawValue + self.lineSubtype.rawValue
    }

    public static func ==(lhs: SectionId, rhs: SectionId) -> Bool {
      return lhs.lineType    == rhs.lineType
          && lhs.lineSubtype == rhs.lineSubtype
    }
  }

  private func convertToSections(lines: [Line]) -> [LineSelectionSection] {
    var linesByType = [SectionId: [Line]]()

    for line in lines {
      let key = SectionId(lineType: line.type, lineSubtype: line.subtype)

      if let _ = linesByType[key] {
        linesByType[key]!.append(line)
      }
      else {
        linesByType[key] = [line]
      }
    }

    return linesByType.map { (sectionId, lines) in
      return LineSelectionSection(sectionId.lineType, sectionId.lineSubtype, sort(lines: lines))
    }
  }

  //MARK: - Ordering

  fileprivate func sort(lines: [Line]) -> [Line] {
    return lines.sorted { (lhs, rhs) in
      let lhsNum = Int(lhs.name)
      let rhsNum = Int(rhs.name)

      if let lhsNum = lhsNum, let rhsNum = rhsNum {
        return lhsNum < rhsNum
      }

      if let _ = lhsNum {
        return true
      }

      if let _ = rhsNum {
        return false
      }

      return lhs.name.caseInsensitiveCompare(rhs.name) == .orderedAscending
    }
  }

  fileprivate func sort(sections: [LineSelectionSection]) -> [LineSelectionSection] {
    return sections.sorted { (lhs, rhs) in
      return order(for: lhs) < self.order(for: rhs)
    }
  }

  private func order(for section: LineSelectionSection) -> Int {
    return 1000 * order(for: section.type) + order(for: section.subtype)
  }

  private func order(for type: LineType) -> Int {
    switch type {
    case .tram: return 0
    case .bus:  return 1
    }
  }

  private func order(for subtype: LineSubtype) -> Int {
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
