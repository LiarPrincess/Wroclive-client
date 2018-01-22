//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit

private typealias Constants = MapViewControllerConstants

extension MapViewController {

  func updateVehicleLocations(_ vehicles: [Vehicle]) {
    let annotations = self.getVehicleAnnotations()
    let updates     = MapAnnotationManager.calculateUpdates(for: annotations, with: vehicles)

    // updated
    UIView.animate(withDuration: Constants.Pin.animationDuration) {
      for (vehicle, annotation) in updates.updatedAnnotations {
        annotation.angle      = CGFloat(vehicle.angle)
        annotation.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)

        if let annotationView = self.mapView.view(for: annotation) as? VehicleAnnotationView {
          annotationView.updateImage()
        }
      }
    }

    // created, removed
    self.mapView.addAnnotations(updates.createdAnnotations)
    self.mapView.removeAnnotations(updates.removedAnnotations)
  }
}
