// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// MARK: - Line

public struct Line: Codable, Equatable, Hashable, CustomStringConvertible {
  public let name: String
  public let type: LineType
  public let subtype: LineSubtype

  public var description: String {
    return "Line(\(self.name), \(self.type), \(self.subtype))"
  }
}

// MARK: - Type

public enum LineType: String, Codable, Equatable, Hashable, CustomStringConvertible {
  case tram
  case bus

  public var description: String {
    switch self {
    case .tram: return "Tram"
    case .bus: return "Bus"
    }
  }
}

// MARK: - Subtype

public enum LineSubtype: String, Codable, Equatable, Hashable, CustomStringConvertible {
  case regular
  case express
  case peakHour
  case suburban
  case zone
  case limited
  case temporary
  case night

  public var description: String {
    switch self {
    case .regular: return "Regular"
    case .express: return "Express"
    case .peakHour: return "Peak-hour"
    case .suburban: return "Suburban"
    case .zone: return "Zone"
    case .limited: return "Limited"
    case .temporary: return "Temporary"
    case .night: return "Night"
    }
  }
}

// MARK: - Array

extension Array where Element == Line {

  public func filter(_ type: LineType) -> [Line] {
    return self.filter { $0.type == type }
  }

  public mutating func sortByLocalizedName() {
    self.sort { lhs, rhs in
      lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
    }
  }
}
