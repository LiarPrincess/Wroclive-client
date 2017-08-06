//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import MapKit

class VehicleLocationAnnotation: NSObject, MKAnnotation {

  // MARK: - Properties

  var vehicleId: String
  var line:      Line

  dynamic var coordinate: CLLocationCoordinate2D
  dynamic var angle:      CLLocationDirection

  // MARK: - Init

  init(from vehicleLocation: VehicleLocation) {
    self.vehicleId  = vehicleLocation.vehicleId
    self.line       = vehicleLocation.line
    self.coordinate = CLLocationCoordinate2D(latitude: vehicleLocation.latitude, longitude: vehicleLocation.longitude)
    self.angle      = CLLocationDirection(vehicleLocation.angle)
  }

  // MARK: - Update

  func fillFrom(vehicleLocation: VehicleLocation) {
    self.vehicleId  = vehicleLocation.vehicleId
    self.line       = vehicleLocation.line
    self.coordinate = CLLocationCoordinate2D(latitude: vehicleLocation.latitude, longitude: vehicleLocation.longitude)
    self.angle      = CLLocationDirection(vehicleLocation.angle)
  }

}
