// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

enum LineSubtype: Int, Codable, Equatable {
  case regular
  case express
  case peakHour
  case suburban
  case zone
  case limited
  case temporary
  case night
}
