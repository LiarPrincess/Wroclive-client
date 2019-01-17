// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum LineType: Int, Codable, Equatable, Hashable, CustomStringConvertible {
  case tram
  case bus

  public var description: String {
    switch self {
    case .tram: return "tram"
    case .bus: return "bus"
    }
  }
}
