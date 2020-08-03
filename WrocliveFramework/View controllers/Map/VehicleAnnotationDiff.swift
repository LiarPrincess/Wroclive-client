// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public struct VehicleAnnotationDiff {

  /// `Annotation` should be updated from given `vehicle`.
  public typealias Update = (annotation: VehicleAnnotation, vehicle: Vehicle)

  public private(set) var added   = [VehicleAnnotation]()
  public private(set) var updated = [Update]()
  public private(set) var removed = [VehicleAnnotation]()

  private init() {}

  public static func calculate(annotations: [VehicleAnnotation],
                               vehicles: [Vehicle]) -> VehicleAnnotationDiff {
    var result = VehicleAnnotationDiff()

    // It may happen that the same vehicleId will be used for multiple vehicles
    // (that's an error on data provider side, but we can't do anything about it).
    // In such case we have to readd those annotations, because if we tried
    // to animate them the UI would get confused.
    let unique = filterUniqueVehicleIds(annotations: annotations)
    var annotationsByVehicleId = groupByVehicleId(annotations: unique)

    // Assign all of the vehicles to either created or updated annotations.
    for vehicle in vehicles {
      if let annotation = annotationsByVehicleId.removeValue(forKey: vehicle.id) {
        let pair = (annotation, vehicle)
        result.updated.append(pair)
      } else {
        result.added.append(VehicleAnnotation(from: vehicle))
      }
    }

    // Remove remaining annotations
    let updatedAnnotations = result.updated.map { $0.annotation }
    result.removed = substractByVehicleId(from: annotations,
                                          values: updatedAnnotations)

    return result
  }
}

private typealias VehicleId = String

private func filterUniqueVehicleIds(
  annotations: [VehicleAnnotation]
) -> [VehicleAnnotation] {
  var processedVehicleIds = Set<VehicleId>()
  var duplicateVehicleIds = Set<VehicleId>()

  for annotation in annotations {
    let vehicleId = annotation.vehicleId

    if processedVehicleIds.contains(vehicleId) {
      duplicateVehicleIds.insert(vehicleId)
    } else {
      processedVehicleIds.insert(vehicleId)
    }
  }

  return annotations.filter { !duplicateVehicleIds.contains($0.vehicleId) }
}

private func groupByVehicleId(
  annotations: [VehicleAnnotation]
) -> [VehicleId:VehicleAnnotation] {
  var result = [VehicleId:VehicleAnnotation]()
  for annotation in annotations {
    assert(result[annotation.vehicleId] == nil)
    result[annotation.vehicleId] = annotation
  }

  return result
}

private func substractByVehicleId(
  from annotations: [VehicleAnnotation],
  values: [VehicleAnnotation]
) -> [VehicleAnnotation] {
  let substractedVehicleIds = Set(values.map { $0.vehicleId })
  return annotations.filter { !substractedVehicleIds.contains($0.vehicleId) }
}
