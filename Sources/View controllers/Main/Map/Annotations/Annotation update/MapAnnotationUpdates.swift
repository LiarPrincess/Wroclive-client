// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

class MapAnnotationUpdates {
  typealias AnnotationAssignment = (vehicle: Vehicle, annotation: VehicleAnnotation)

  /// New annotations
  var createdAnnotations = [VehicleAnnotation]()

  // Annotations which vehicle has moved
  var updatedAnnotations = [AnnotationAssignment]()

  /// Removed annotation
  var removedAnnotations = [VehicleAnnotation]()
}
