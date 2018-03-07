//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

class MapAnnotationUpdates {
  typealias AnnotationAssignment = (vehicle: Vehicle, annotation: VehicleAnnotation)

  /// New annotations
  var createdAnnotations = [VehicleAnnotation]()

  // Annotations which vehicle has moved
  var updatedAnnotations = [AnnotationAssignment]()

  /// Removed annotation
  var removedAnnotations = [VehicleAnnotation]()
}
