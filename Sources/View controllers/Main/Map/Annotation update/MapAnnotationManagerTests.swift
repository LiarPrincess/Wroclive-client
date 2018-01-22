//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
@testable import Wroclive

final class MapAnnotationManagerTests: XCTestCase {

  // MARK: - Sanity checks

  func test_newVehicle_createsAnnotation() {
    let annotations = [VehicleAnnotation]()
    let vehicles    = [Vehicle(id: "0", num: 3.0)]

    let updates = MapAnnotationManager.calculateUpdates(for: annotations, with: vehicles)

    XCTAssert(updates.createdAnnotations, contains: VehicleAnnotation(from: vehicles[0]))
    XCTAssert(updates.updatedAnnotations.isEmpty)
    XCTAssert(updates.removedAnnotations.isEmpty)
  }

  func test_existingVehicle_updatesAnnotation() {
    let annotations = [VehicleAnnotation(from: Vehicle(id: "0", num: 3.0))]
    let vehicles    = [Vehicle(id: "0", num: 5.0)]

    let updates = MapAnnotationManager.calculateUpdates(for: annotations, with: vehicles)

    XCTAssert(updates.createdAnnotations.isEmpty)
    XCTAssert(updates.updatedAnnotations, contains: (vehicles[0], annotations[0]))
    XCTAssert(updates.removedAnnotations.isEmpty)
  }

  func test_noVehicles_removesAnnotation() {
    let annotations = [VehicleAnnotation(from: Vehicle(id: "0", num: 3.0))]
    let vehicles    = [Vehicle]()

    let updates = MapAnnotationManager.calculateUpdates(for: annotations, with: vehicles)

    XCTAssert(updates.createdAnnotations.isEmpty)
    XCTAssert(updates.updatedAnnotations.isEmpty)
    XCTAssert(updates.removedAnnotations, contains: annotations[0])
  }

  func test_duplicatedAnnotation_createsNewAnnotation() {
    let annotations = [
      VehicleAnnotation(from: Vehicle(id: "0", num: 3.0)),
      VehicleAnnotation(from: Vehicle(id: "0", num: 5.0))
    ]

    let vehicles = [Vehicle(id: "0", num: 5.0)]

    let updates = MapAnnotationManager.calculateUpdates(for: annotations, with: vehicles)

    XCTAssert(updates.createdAnnotations, contains: VehicleAnnotation(from: vehicles[0]))
    XCTAssert(updates.updatedAnnotations.isEmpty)
    XCTAssert(updates.removedAnnotations, contains: annotations[0])
    XCTAssert(updates.removedAnnotations, contains: annotations[1])
  }

  // MARK: - Interleaved tests

  /// Basically all of the tests above in an single run.
  func test_multipleVehicles_returnsValidValue() {
    let annotationUpdate = VehicleAnnotation(from: Vehicle(id: "annotationUpdate", num: 3.0))
    let annotationRemove = VehicleAnnotation(from: Vehicle(id: "annotationRemove", num: 3.0))
    let annotationReadd0 = VehicleAnnotation(from: Vehicle(id: "annotationReadd0", num: 3.0))
    let annotationReadd1 = VehicleAnnotation(from: Vehicle(id: "annotationReadd1", num: 3.0))
    let annotations = [annotationUpdate, annotationRemove, annotationReadd0, annotationReadd1]

    let vehicleCreate = Vehicle(id: "annotationCreate", num: 3.0)
    let vehicleUpdate = Vehicle(id: "annotationUpdate", num: 5.0)
    let vehicleReadd  = Vehicle(id: "annotationReadd",  num: 5.0)
    let vehicles = [vehicleCreate, vehicleUpdate, vehicleReadd]

    let updates = MapAnnotationManager.calculateUpdates(for: annotations, with: vehicles)

    XCTAssert(updates.createdAnnotations, contains: VehicleAnnotation(from: vehicleCreate))
    XCTAssert(updates.createdAnnotations, contains: VehicleAnnotation(from: vehicleReadd))
    XCTAssert(updates.updatedAnnotations, contains: (vehicleUpdate, annotationUpdate))
    XCTAssert(updates.removedAnnotations, contains: annotationRemove)
    XCTAssert(updates.removedAnnotations, contains: annotationReadd0)
    XCTAssert(updates.removedAnnotations, contains: annotationReadd1)
  }
}

// MARK: - Vehicle init

extension Vehicle {
  init(id: String, num: Double) {
    let line = Line(name: "line", type: .tram, subtype: .regular)
    self.init(id: id, line: line, latitude: num, longitude: num, angle: num)
  }
}

// MARK: - Asserts

private func XCTAssert(_ annotations: [VehicleAnnotation], contains value: VehicleAnnotation, file: StaticString = #file, line: UInt = #line) {
  let containsValue = annotations.contains { isEqual($0, value) }
  XCTAssert(containsValue, file: file, line: line)
}

typealias AnnotationAssignment = (vehicle: Vehicle, annotation: VehicleAnnotation)

private func XCTAssert(_ assignments: [AnnotationAssignment], contains value: AnnotationAssignment, file: StaticString = #file, line: UInt = #line) {
  let containsValue = assignments.contains {
    isEqual($0.vehicle, value.vehicle) && isEqual($0.annotation, value.annotation)
  }

  XCTAssert(containsValue, file: file, line: line)
}

// MARK: - Equatable

private func isEqual(_ lhs: Vehicle, _ rhs: Vehicle) -> Bool {
  return lhs.id   == rhs.id
      && lhs.line == rhs.line
      && abs(lhs.latitude  - rhs.latitude)  < 0.1
      && abs(lhs.longitude - rhs.longitude) < 0.1
      && abs(lhs.angle     - rhs.angle)     < 0.1
}

private func isEqual(_ lhs: VehicleAnnotation, _ rhs: VehicleAnnotation) -> Bool {
  return lhs.vehicleId  == rhs.vehicleId
      && lhs.line       == rhs.line
      && lhs.angle      == rhs.angle
      && abs(lhs.coordinate.latitude  - rhs.coordinate.latitude)  < 0.1
      && abs(lhs.coordinate.longitude - rhs.coordinate.longitude) < 0.1
}
