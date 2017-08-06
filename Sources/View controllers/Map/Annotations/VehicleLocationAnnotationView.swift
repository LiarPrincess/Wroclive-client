//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import MapKit
import Foundation

class VehicleLocationAnnotationView: MKAnnotationView {

  // MARK: - Init

  init(vehicleLocation: VehicleLocationAnnotation, reuseIdentifier: String?) {
    super.init(annotation: vehicleLocation, reuseIdentifier: reuseIdentifier)

    self.transform      = CGAffineTransform(rotationAngle: vehicleLocation.angleRad)
    self.isDraggable    = false
    self.canShowCallout = false
    self.image          = #imageLiteral(resourceName: "mapPin")
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Set vehicle location

  func setVehicleLocationAnnotation(_ vehicleLcation: VehicleLocationAnnotation) {
    self.annotation = vehicleLcation
    self.redraw()
  }

  func redraw() {
    let vehicleLocationAnnotation = self.annotation! as! VehicleLocationAnnotation
    self.transform = CGAffineTransform(rotationAngle: vehicleLocationAnnotation.angleRad)
  }

}
