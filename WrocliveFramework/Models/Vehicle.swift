// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public struct Vehicle: CustomStringConvertible {
  public let id:   String
  public let line: Line

  public let latitude:  Double
  public let longitude: Double
  public let angle:     Double

  public var description: String {
    let location = "Location(\(self.latitude), \(self.longitude), \(self.angle))"
    return "Vehicle(\(self.id), \(self.line) @ \(location))"
  }
}
