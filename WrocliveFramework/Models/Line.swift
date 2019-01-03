// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public struct Line: Codable, Equatable, CustomStringConvertible {
  public let name:    String
  public let type:    LineType
  public let subtype: LineSubtype

  public var description: String {
    return "Line(\(self.name), \(self.type), \(self.subtype))"
  }
}
