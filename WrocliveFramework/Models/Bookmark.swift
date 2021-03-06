// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public struct Bookmark: Codable, Equatable, CustomStringConvertible {

  public let name: String
  public let lines: [Line]

  public var description: String {
    return "Bookmark(\(self.name), \(self.lines))"
  }

  public init(name: String, lines: [Line]) {
    self.name = name
    self.lines = lines
  }
}
