//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit

private typealias Constants = MapViewControllerConstants

private class AnnotationUpdates {
  typealias AnnotationAssignment = (vehicle: Vehicle, annotation: VehicleAnnotation)

  // Annotations which vehicle has moved
  var updatedAnnotations = [AnnotationAssignment]()

  /// Annotations reassigned to another vehicle
  var reasignedAnnotations = [AnnotationAssignment]()

  /// New annotations
  var createdAnnotations = [VehicleAnnotation]()

  /// Removed annotation
  var removedAnnotations = [VehicleAnnotation]()
}

extension MapViewController {

  func updateVehicleLocations(_ vehicles: [Vehicle]) {
    let updates = self.calculateUpdates(vehicles)

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

    // reassigned
    for (vehicle, annotation) in updates.reasignedAnnotations {
      annotation.fillFrom(vehicle)

      if let annotationView = self.mapView.view(for: annotation) as? VehicleAnnotationView {
        annotationView.updateImage()
        annotationView.updateLabel()
      }
    }

    // created, removed
    self.mapView.addAnnotations(updates.createdAnnotations)
    self.mapView.removeAnnotations(updates.removedAnnotations)
  }

  // MARK: Calculate updates

  private func calculateUpdates(_ vehicles: [Vehicle]) -> AnnotationUpdates {
    let result = AnnotationUpdates()

    // update annotations for already existing vehicles
    var annotationsByVehicleId = self.groupByVehicleId(self.getVehicleAnnotations())
    var unassignedVehicles = [Vehicle]()

    for vehicle in vehicles {
      if let annotation = annotationsByVehicleId.removeValue(forKey: vehicle.id) {
        result.updatedAnnotations.append((vehicle, annotation))
      }
      else { unassignedVehicles.append(vehicle) }
    }

    // assign/create annotations for new vehicles
    var unassignedAnnotations = Array(annotationsByVehicleId.values)

    for vehicle in unassignedVehicles {
      if let annotation = unassignedAnnotations.popLast() {
        result.reasignedAnnotations.append((vehicle, annotation))
      }
      else { result.createdAnnotations.append(VehicleAnnotation(from: vehicle)) }
    }

    // remove remaining annotations
    result.removedAnnotations = unassignedAnnotations

    return result
  }

  private func getVehicleAnnotations() -> [VehicleAnnotation] {
    return self.mapView.annotations.flatMap { return $0 as? VehicleAnnotation }
  }

  private func groupByVehicleId(_ annotations: [VehicleAnnotation]) -> [String:VehicleAnnotation] {
    var result = [String:VehicleAnnotation]()
    for annotation in annotations {
      result[annotation.vehicleId] = annotation
    }
    return result
  }
}
