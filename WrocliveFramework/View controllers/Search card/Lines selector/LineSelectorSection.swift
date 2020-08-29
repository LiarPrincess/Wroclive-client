// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

private typealias SectionNames = Localizable.Search.Sections

public struct LineSelectorSection: Equatable {

  private let subtype: LineSubtype
  public let lines: [Line]

  public init(subtype: LineSubtype, lines: [Line]) {
    assert(lines.allSatisfy { $0.subtype == subtype })
    self.subtype = subtype
    self.lines = lines
  }

  public var name: String {
    switch subtype {
    case .regular: return SectionNames.regular
    case .express: return SectionNames.express
    case .peakHour: return SectionNames.peakHour
    case .suburban: return SectionNames.suburban
    case .zone: return SectionNames.zone
    case .limited: return SectionNames.limited
    case .temporary: return SectionNames.temporary
    case .night: return SectionNames.night
    }
  }

  // MARK: - Create

  public struct CreateResult {
    public let tram: [LineSelectorSection]
    public let bus: [LineSelectorSection]
  }

  private struct TmpSection {
    fileprivate let type: LineType
    fileprivate let subtype: LineSubtype
    fileprivate var lines: [Line]

    fileprivate init(line: Line) {
      self.type = line.type
      self.subtype = line.subtype
      self.lines = [line]
    }
  }

  public static func create(from lines: [Line]) -> CreateResult {
    var tmpSections = [TmpSection]()

    for line in lines {
      let index = tmpSections.firstIndex {
        $0.type == line.type && $0.subtype == line.subtype
      }

      if let index = index {
        tmpSections[index].lines.append(line)
      } else {
        let section = TmpSection(line: line)
        tmpSections.append(section)
      }
    }

    var tramSections = [LineSelectorSection]()
    var busSections = [LineSelectorSection]()

    for index in tmpSections.indices {
      // Use 'tmpSections[index]' to avoid COW
      tmpSections[index].lines.sortByLocalizedName()

      let tmpSection = tmpSections[index]
      let section = LineSelectorSection(subtype: tmpSection.subtype,
                                        lines: tmpSection.lines)

      switch tmpSection.type {
      case .tram:
        tramSections.append(section)
      case .bus:
        busSections.append(section)
      }
    }

    Self.sort(sections: &tramSections)
    Self.sort(sections: &busSections)
    return CreateResult(tram: tramSections, bus: busSections)
  }

  private static func sort(sections: inout [LineSelectorSection]) {
    sections.sort { lhs, rhs in
      let lhsOrder = Self.getSectionOrder(subtype: lhs.subtype)
      let rhsOrder = Self.getSectionOrder(subtype: rhs.subtype)
      return lhsOrder < rhsOrder
    }
  }

  /// Order in which sections appear in `LineSelector`.
  private static func getSectionOrder(subtype: LineSubtype) -> Int {
    switch subtype {
    case .express: return 0
    case .regular: return 1
    case .night: return 2
    case .suburban: return 3
    case .peakHour: return 4
    case .zone: return 5
    case .limited: return 6
    case .temporary: return 7
    }
  }
}
