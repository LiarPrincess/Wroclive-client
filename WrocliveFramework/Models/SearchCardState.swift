// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public struct SearchCardState: Codable, Equatable, CustomStringConvertible {

  public let page: LineType
  public let selectedLines: [Line]

  public static let `default` = SearchCardState(page: .tram, selectedLines: [])

  public var description: String {
    return "SearchCardState(\(self.page), \(self.selectedLines))"
  }
}
