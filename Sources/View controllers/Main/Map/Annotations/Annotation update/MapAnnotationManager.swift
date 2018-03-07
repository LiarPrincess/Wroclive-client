//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

enum MapAnnotationManager {

  static func calculateUpdates(for annotations: [VehicleAnnotation], with vehicles: [Vehicle]) -> MapAnnotationUpdates {
    let result = MapAnnotationUpdates()

    // annotations with duplicate vehicleId will be readded, as we can't animate location change for them
    let uniqueAnnotations            = filterUniqueVehicleIds(annotations)
    var uniqueAnnotationsByVehicleId = groupByVehicleId(uniqueAnnotations)

    // assign all of the vehicles to either created or updated annotations
    for vehicle in vehicles {
      if let annotation = uniqueAnnotationsByVehicleId.removeValue(forKey: vehicle.id) {
        result.updatedAnnotations.append((vehicle, annotation))
      }
      else { result.createdAnnotations.append(VehicleAnnotation(from: vehicle)) }
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
