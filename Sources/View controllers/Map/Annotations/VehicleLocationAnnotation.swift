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

  var angle:    CGFloat
  var angleRad: CGFloat { return self.angle.rad }

  // MARK: - Init

  init(from vehicleLocation: VehicleLocation) {
    self.vehicleId  = vehicleLocation.vehicleId
    self.line       = vehicleLocation.line
    self.coordinate = CLLocationCoordinate2D(latitude: vehicleLocation.latitude, longitude: vehicleLocation.longitude)
    self.angle      = CGFloat(vehicleLocation.angle)
  }

  // MARK: - Update

  func fillFrom(_ vehicleLocation: VehicleLocation) {
    self.vehicleId  = vehicleLocation.vehicleId
    self.line       = vehicleLocation.line
    self.coordinate = CLLocationCoordinate2D(latitude: vehicleLocation.latitude, longitude: vehicleLocation.longitude)
    self.angle      = CGFloat(vehicleLocation.angle)
  }

}
