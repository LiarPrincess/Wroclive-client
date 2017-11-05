//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import MapKit

class VehicleAnnotation: NSObject, MKAnnotation {

  // MARK: - Properties

  dynamic var vehicleId:  String
  dynamic var line:       Line
  dynamic var angle:      CGFloat
  dynamic var coordinate: CLLocationCoordinate2D

  // MARK: - Init

  init(from vehicle: Vehicle) {
    self.vehicleId  = vehicle.id
    self.line       = vehicle.line
    self.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)
    self.angle      = CGFloat(vehicle.angle)
  }

  // MARK: - Update

  func fillFrom(_ vehicle: Vehicle) {
    self.vehicleId  = vehicle.id
    self.line       = vehicle.line
    self.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)
    self.angle      = CGFloat(vehicle.angle)
  }
}
