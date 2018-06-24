// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import MapKit

class VehicleAnnotation: NSObject, MKAnnotation {

  var vehicleId: String
  var line:      Line
  var angle:     CGFloat
  dynamic var coordinate: CLLocationCoordinate2D

  init(from vehicle: Vehicle) {
    self.vehicleId  = vehicle.id
    self.line       = vehicle.line
    self.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)
    self.angle      = CGFloat(vehicle.angle)
  }

  func update(from vehicle: Vehicle) {
    self.vehicleId  = vehicle.id
    self.line       = vehicle.line
    self.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)
    self.angle      = CGFloat(vehicle.angle)
  }
}
