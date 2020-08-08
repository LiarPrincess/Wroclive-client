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
}
