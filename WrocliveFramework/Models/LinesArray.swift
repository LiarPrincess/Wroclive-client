// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

extension Array where Element == Line {
  public func filter(_ type: LineType) -> [Line] {
    return self.filter { $0.type == type }
  }

  public func sortedByName() -> [Line] {
    return self.sorted { lhs, rhs in lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending }
  }
}
