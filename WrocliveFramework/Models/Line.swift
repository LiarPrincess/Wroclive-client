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

public enum LineType: Int, Codable, Equatable, Hashable, CustomStringConvertible {
  case tram = 0
  case bus = 1

  public var description: String {
    switch self {
    case .tram: return "tram"
    case .bus: return "bus"
    }
  }
}

// MARK: - Subtype

public enum LineSubtype: Int, Codable, Equatable, Hashable, CustomStringConvertible {
  case regular = 0
  case express = 1
  case peakHour = 2
  case suburban = 3
  case zone = 4
  case limited = 5
  case temporary = 6
  case night = 7

  public var description: String {
    switch self {
    case .regular: return "regular"
    case .express: return "express"
    case .peakHour: return "peakHour"
    case .suburban: return "suburban"
    case .zone: return "zone"
    case .limited: return "limited"
    case .temporary: return "temporary"
    case .night: return "night"
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
