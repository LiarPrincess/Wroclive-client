// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public struct Vehicle: CustomStringConvertible, Equatable {

  public let id: String
  public let line: Line

  public let latitude: Double
  public let longitude: Double
  public let angle: Double

  public var description: String {
    let location = "Location(\(self.latitude), \(self.longitude), \(self.angle))"
    return "Vehicle(\(self.id), \(self.line) @ \(location))"
  }

  public init(id: String,
              line: Line,
              latitude: Double,
              longitude: Double,
              angle: Double) {
    self.id = id
    self.line = line
    self.latitude = latitude
    self.longitude = longitude
    self.angle = angle
  }
}
