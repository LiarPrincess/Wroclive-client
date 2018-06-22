// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

extension Array {
  func grouped<Key: Hashable>(_ grouping: (Element) -> Key) -> [Key:[Element]] {
    var result: [Key:[Element]] = [:]

    for value in self {
      let key = grouping(value)
      result[key, default: []].append(value)
    }
    return result
  }
}
