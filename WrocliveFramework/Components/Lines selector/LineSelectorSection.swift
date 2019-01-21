// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

private typealias Localization = Localizable.Search.Sections

public typealias LineSelectorSection = RxSectionModel<LineSelectorSectionData, Line>

public struct LineSelectorSectionData: Equatable {
  public let lineSubtype: LineSubtype

  public var lineSubtypeTranslation: String {
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

  public init(for lineSubtype: LineSubtype) {
    self.lineSubtype = lineSubtype
  }

  public static func == (lhs: LineSelectorSectionData, rhs: LineSelectorSectionData) -> Bool {
    return lhs.lineSubtype == rhs.lineSubtype
  }
}
