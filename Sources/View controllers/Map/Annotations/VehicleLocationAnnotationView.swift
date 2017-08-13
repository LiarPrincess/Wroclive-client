//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import MapKit
import Foundation

fileprivate typealias Layout = MapViewControllerConstants.Layout

class VehicleLocationAnnotationView: MKAnnotationView {

  // MARK: - Init

  init(vehicleLocation: VehicleLocationAnnotation, reuseIdentifier: String?) {
    super.init(annotation: vehicleLocation, reuseIdentifier: reuseIdentifier)

    self.transform      = CGAffineTransform(rotationAngle: vehicleLocation.angleRad)
    self.isDraggable    = false
    self.canShowCallout = false
    self.redraw()
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
    let annotation = self.annotation! as! VehicleLocationAnnotation

    let isBus = annotation.line.type == .bus
    let color = isBus ? Theme.current.colorScheme.bus : Theme.current.colorScheme.tram

    self.image     = StyleKit2.drawPinImage(size: Layout.pinImageSize, background: color, renderingMode: .alwaysTemplate)
    self.transform = CGAffineTransform(rotationAngle: annotation.angleRad)
  }

}
