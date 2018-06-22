// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

@testable import Wroclive

extension Vehicle: Equatable {
  public static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
    return true
      && lhs.id        == rhs.id
      && lhs.line      == rhs.line
      // we actually can do this, even though following are floating points:
      && lhs.latitude  == rhs.latitude
      && lhs.longitude == rhs.longitude
      && lhs.angle     == rhs.angle
  }
}
