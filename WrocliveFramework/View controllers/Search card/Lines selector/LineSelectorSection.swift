// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public struct LineSelectorSection: Equatable {

  public let lineSubtype: LineSubtype
  public let lines: [Line]

  public var name: String {
    typealias L = Localizable.Search.Sections

    switch self.lineSubtype {
    case .regular:   return L.regular
    case .express:   return L.express
    case .peakHour:  return L.peakHour
    case .suburban:  return L.suburban
    case .zone:      return L.zone
    case .limited:   return L.limited
    case .temporary: return L.temporary
    case .night:     return L.night
    }
  }

  public init(for lineSubtype: LineSubtype, lines: [Line]) {
    assert(lines.allSatisfy { $0.subtype == lineSubtype })

    self.lineSubtype = lineSubtype
    self.lines = lines
  }

  public static func create(from lines: [Line]) -> [LineSelectorSection] {
     let linesBySubtype = lines.group { $0.subtype }

     var result = [LineSelectorSection]()
     for (subtype, var lines) in linesBySubtype {
       lines.sortByLocalizedName()
       result.append(LineSelectorSection(for: subtype, lines: lines))
     }

     result.sort { lhs, rhs in
       let lhsOrder = Self.getSectionOrder(subtype: lhs.lineSubtype)
       let rhsOrder = Self.getSectionOrder(subtype: rhs.lineSubtype)
       return lhsOrder < rhsOrder
     }

     return result
   }

  private static func getSectionOrder(subtype: LineSubtype) -> Int {
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
