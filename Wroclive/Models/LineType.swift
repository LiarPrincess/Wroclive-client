// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

enum LineType: Int, Codable, Equatable, CustomDebugStringConvertible {
  case tram
  case bus

  var debugDescription: String {
    switch self {
    case .tram: return "tram"
    case .bus: return "bus"
    }
  }
}
