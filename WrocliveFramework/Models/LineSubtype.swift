// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum LineSubtype: Int, Codable, Equatable, Hashable, CustomStringConvertible {
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
