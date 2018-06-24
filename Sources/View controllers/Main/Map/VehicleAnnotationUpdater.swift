// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

class VehicleAnnotationUpdates {
  typealias AnnotationAssignment = (vehicle: Vehicle, annotation: VehicleAnnotation)

  var newAnnotations     = [VehicleAnnotation]()
  var updatedAnnotations = [AnnotationAssignment]()
  var removedAnnotations = [VehicleAnnotation]()
}

enum VehicleAnnotationUpdater {

  static func calculateUpdates(for annotations: [VehicleAnnotation], from vehicles: [Vehicle]) -> VehicleAnnotationUpdates {
    let result = VehicleAnnotationUpdates()

    // annotations with duplicate vehicleId will be readded, as we can't animate location change for them
    let uniqueAnnotations            = filterUniqueVehicleIds(annotations)
    var uniqueAnnotationsByVehicleId = groupByVehicleId(uniqueAnnotations)

    // assign all of the vehicles to either created or updated annotations
    for vehicle in vehicles {
      if let existingAnnotation = uniqueAnnotationsByVehicleId.removeValue(forKey: vehicle.id) {
        result.updatedAnnotations.append((vehicle, existingAnnotation))
      }
      else { result.newAnnotations.append(VehicleAnnotation(from: vehicle)) }
    }

    // remove remaining annotations
    let updatedAnnotations = result.updatedAnnotations.map { $0.annotation }
    result.removedAnnotations = substractByVehicleId(from: annotations, values: updatedAnnotations)

    return result
  }
}

private func filterUniqueVehicleIds(_ annotations: [VehicleAnnotation]) -> [VehicleAnnotation] {
  var processedVehicleIds = Set<String>()
  var duplicateVehicleIds = Set<String>()

  for annotation in annotations {
    let vehicleId = annotation.vehicleId
    if processedVehicleIds.contains(vehicleId) {
      duplicateVehicleIds.insert(vehicleId)
    }
    else { processedVehicleIds.insert(vehicleId) }
  }

  return annotations.filter { !duplicateVehicleIds.contains($0.vehicleId) }
}

private func groupByVehicleId(_ annotations: [VehicleAnnotation]) -> [String:VehicleAnnotation] {
  var result = [String:VehicleAnnotation]()
  for annotation in annotations {
    result[annotation.vehicleId] = annotation
  }
  return result
}

private func substractByVehicleId(from annotations: [VehicleAnnotation], values: [VehicleAnnotation]) -> [VehicleAnnotation] {
  let substractedVehicleIds = Set(values.map { $0.vehicleId })
  return annotations.filter { !substractedVehicleIds.contains($0.vehicleId) }
}
