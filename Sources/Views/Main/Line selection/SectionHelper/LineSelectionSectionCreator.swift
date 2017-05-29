//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit

//MARK: - LineSelectionSectionCreatorProtocol

protocol LineSelectionSectionCreatorProtocol {
  func create(from lines:[Line]) -> [LineSelectionSection]
}

//MARK: - LineSelectionSectionCreator

class LineSelectionSectionCreator: LineSelectionSectionCreatorProtocol {
  func create(from lines:[Line]) -> [LineSelectionSection] {
    let sections = self.convertToSections(lines: lines)
    return self.sort(sections: sections)
  }
}

//MARK: - Convert

extension LineSelectionSectionCreator {

  fileprivate func convertToSections(lines: [Line]) -> [LineSelectionSection] {
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

}

//MARK: - Ordering

extension LineSelectionSectionCreator {

  fileprivate func sort(lines: [Line]) -> [Line] {
    return lines.sorted { (lhs, rhs) in
      return lhs.name.caseInsensitiveCompare(rhs.name) == .orderedAscending
    }
  }

  fileprivate func sort(sections: [LineSelectionSection]) -> [LineSelectionSection] {
    return sections.sorted { (lhs, rhs) in
      return order(for: lhs) < self.order(for: rhs)
    }
  }

  private func order(for section: LineSelectionSection) -> Int {
    return 1000 * order(for: section.lineType) + order(for: section.lineSubtype)
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

    case .hour:      return 2
    case .night:     return 3
    case .suburban:  return 4

    case .zone:      return 5
    case .limited:   return 6
    case .temporary: return 7
    }
  }

}
