// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

struct SearchCardState: Codable, Equatable, CustomDebugStringConvertible {
  let page:          LineType
  let selectedLines: [Line]

  var debugDescription: String {
    return "SearchCardState(\(self.page), \(self.selectedLines))"
  }

  static let `default`: SearchCardState = SearchCardState(page: .tram, selectedLines: [])
}
