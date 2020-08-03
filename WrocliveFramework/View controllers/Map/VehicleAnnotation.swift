// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import MapKit

public final class VehicleAnnotation: NSObject, MKAnnotation {

  public var vehicleId: String
  public var line:      Line
  public var angle:     CGFloat
  public dynamic var coordinate: CLLocationCoordinate2D

  public init(from vehicle: Vehicle) {
    self.vehicleId  = vehicle.id
    self.line       = vehicle.line
    self.angle      = CGFloat(vehicle.angle)
    self.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude,
                                             longitude: vehicle.longitude)
  }

  public func update(from vehicle: Vehicle) {
    self.vehicleId  = vehicle.id
    self.line       = vehicle.line
    self.angle      = CGFloat(vehicle.angle)
    self.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude,
                                             longitude: vehicle.longitude)
  }
}
