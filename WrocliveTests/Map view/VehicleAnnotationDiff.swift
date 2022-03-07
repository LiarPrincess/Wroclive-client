// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import WrocliveTestsShared
@testable import WrocliveFramework

final class VehicleAnnotationDiffTests: XCTestCase {

  // MARK: - Sanity checks

  func test_newVehicle_createsNewAnnotation() {
    let annotations = [VehicleAnnotation]()
    let vehicles = [self.createVehicle(id: "0", num: 3.0)]

    let diff = self.calculateDiff(annotations: annotations, vehicles: vehicles)

    let addedAnnotation = self.createAnnotation(from: vehicles[0])
    XCTAssertContains(diff.added, annotation: addedAnnotation)
    XCTAssert(diff.updated.isEmpty)
    XCTAssert(diff.removed.isEmpty)
  }

  func test_existingVehicle_updatesAnnotation() {
    let annotations = [self.createAnnotation(id: "0", num: 3.0)]
    let vehicles = [self.createVehicle(id: "0", num: 5.0)]

    let diff = self.calculateDiff(annotations: annotations, vehicles: vehicles)

    XCTAssert(diff.added.isEmpty)
    XCTAssertContains(diff.updated, item: (annotations[0], vehicles[0]))
    XCTAssert(diff.removed.isEmpty)
  }

  func test_missingVehicle_removesAnnotation() {
    let annotations = [self.createAnnotation(id: "0", num: 3.0)]
    let vehicles = [Vehicle]()

    let diff = self.calculateDiff(annotations: annotations, vehicles: vehicles)

    XCTAssert(diff.added.isEmpty)
    XCTAssert(diff.updated.isEmpty)
    XCTAssertContains(diff.removed, annotation: annotations[0])
  }

  /// This may happen when we get non-unique vehicleIds from provider
  /// In such case we should remove old annotations and crete new ones
  func test_duplicatedAnnotation_createsNewAnnotation() {
    let annotations = [
      self.createAnnotation(id: "0", num: 3.0),
      self.createAnnotation(id: "0", num: 5.0)
    ]

    let vehicles = [
      self.createVehicle(id: "0", num: 7.0),
      self.createVehicle(id: "0", num: 9.0)
    ]

    let diff = self.calculateDiff(annotations: annotations, vehicles: vehicles)

    XCTAssertContains(diff.added, annotation: VehicleAnnotation(from: vehicles[0]))
    XCTAssertContains(diff.added, annotation: VehicleAnnotation(from: vehicles[1]))
    XCTAssert(diff.updated.isEmpty)
    XCTAssertContains(diff.removed, annotation: annotations[0])
    XCTAssertContains(diff.removed, annotation: annotations[1])
  }

  // MARK: - Interleaved tests

  /// Basically all of the tests above in an single run.
  func test_multipleVehicles_returnsValidValue() {
    let annotationUpdate = self.createAnnotation(id: "annotationUpdate", num: 3.0)
    let annotationRemove = self.createAnnotation(id: "annotationRemove", num: 3.0)
    let annotationReadd0 = self.createAnnotation(id: "annotationReadd0", num: 3.0)
    let annotationReadd1 = self.createAnnotation(id: "annotationReadd1", num: 3.0)
    let annotations = [annotationUpdate, annotationRemove, annotationReadd0, annotationReadd1]

    let vehicleCreate = self.createVehicle(id: "annotationCreate", num: 3.0)
    let vehicleUpdate = self.createVehicle(id: "annotationUpdate", num: 5.0)
    let vehicleReadd = self.createVehicle(id: "annotationReadd", num: 5.0)
    let vehicles = [vehicleCreate, vehicleUpdate, vehicleReadd]

    let diff = self.calculateDiff(annotations: annotations, vehicles: vehicles)

    XCTAssertContains(diff.added, annotation: VehicleAnnotation(from: vehicleCreate))
    XCTAssertContains(diff.added, annotation: VehicleAnnotation(from: vehicleReadd))
    XCTAssertContains(diff.updated, item: (annotationUpdate, vehicleUpdate))
    XCTAssertContains(diff.removed, annotation: annotationRemove)
    XCTAssertContains(diff.removed, annotation: annotationReadd0)
    XCTAssertContains(diff.removed, annotation: annotationReadd1)
  }

  // MARK: - Helpers

  private func calculateDiff(annotations: [VehicleAnnotation],
                             vehicles: [Vehicle]) -> VehicleAnnotationDiff {
    return VehicleAnnotationDiff.calculate(
      annotations: annotations,
      vehicles: vehicles
    )
  }

  private func createVehicle(id: String, num: Double) -> Vehicle {
    let line = Line(name: "line", type: .tram, subtype: .regular)
    return Vehicle(id: id,
                   line: line,
                   latitude: num,
                   longitude: num,
                   angle: num)
  }

  private func createAnnotation(id: String, num: Double) -> VehicleAnnotation {
    let vehicle = self.createVehicle(id: id, num: num)
    return self.createAnnotation(from: vehicle)
  }

  private func createAnnotation(from vehicle: Vehicle) -> VehicleAnnotation {
    return VehicleAnnotation(from: vehicle)
  }
}
