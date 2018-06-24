// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import Wroclive

final class VehicleAnnotationUpdaterTests: TestCase {

  // MARK: - Sanity checks

  func test_withNewVehicle_createsAnnotation() {
    let annotations = [VehicleAnnotation]()
    let vehicles    = [self.createVehicle(id: "0", num: 3.0)]

    let updates = VehicleAnnotationUpdater.calculateUpdates(for: annotations, from: vehicles)

    XCTAssertContains(updates.newAnnotations, item: self.createAnnotation(from: vehicles[0]))
    XCTAssert(updates.updatedAnnotations.isEmpty)
    XCTAssert(updates.removedAnnotations.isEmpty)
  }

  func test_forExistingVehicle_updatesAnnotation() {
    let annotations = [self.createAnnotation(id: "0", num: 3.0)]
    let vehicles    = [self.createVehicle(id: "0", num: 5.0)]

    let updates = VehicleAnnotationUpdater.calculateUpdates(for: annotations, from: vehicles)

    XCTAssert(updates.newAnnotations.isEmpty)
    XCTAssertContains(updates.updatedAnnotations, item: (vehicles[0], annotations[0]))
    XCTAssert(updates.removedAnnotations.isEmpty)
  }

  func test_withoutVehicles_removesAnnotation() {
    let annotations = [self.createAnnotation(id: "0", num: 3.0)]
    let vehicles    = [Vehicle]()

    let updates = VehicleAnnotationUpdater.calculateUpdates(for: annotations, from: vehicles)

    XCTAssert(updates.newAnnotations.isEmpty)
    XCTAssert(updates.updatedAnnotations.isEmpty)
    XCTAssertContains(updates.removedAnnotations, item: annotations[0])
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

    let updates = VehicleAnnotationUpdater.calculateUpdates(for: annotations, from: vehicles)

    XCTAssertContains(updates.newAnnotations, item: VehicleAnnotation(from: vehicles[0]))
    XCTAssertContains(updates.newAnnotations, item: VehicleAnnotation(from: vehicles[1]))
    XCTAssert(updates.updatedAnnotations.isEmpty)
    XCTAssertContains(updates.removedAnnotations, item: annotations[0])
    XCTAssertContains(updates.removedAnnotations, item: annotations[1])
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
    let vehicleReadd  = self.createVehicle(id: "annotationReadd",  num: 5.0)
    let vehicles = [vehicleCreate, vehicleUpdate, vehicleReadd]

    let updates = VehicleAnnotationUpdater.calculateUpdates(for: annotations, from: vehicles)

    XCTAssertContains(updates.newAnnotations, item: VehicleAnnotation(from: vehicleCreate))
    XCTAssertContains(updates.newAnnotations, item: VehicleAnnotation(from: vehicleReadd))
    XCTAssertContains(updates.updatedAnnotations, item: (vehicleUpdate, annotationUpdate))
    XCTAssertContains(updates.removedAnnotations, item: annotationRemove)
    XCTAssertContains(updates.removedAnnotations, item: annotationReadd0)
    XCTAssertContains(updates.removedAnnotations, item: annotationReadd1)
  }

  // MARK: - Helpers

  private func createVehicle(id: String, num: Double) -> Vehicle {
    return Vehicle(
      id:        id,
      line:      Line(name: "line", type: .tram, subtype: .regular),
      latitude:  num,
      longitude: num,
      angle:     num
    )
  }

  private func createAnnotation(id: String, num: Double) -> VehicleAnnotation {
    let vehicle = createVehicle(id: id, num: num)
    return self.createAnnotation(from: vehicle)
  }

  private func createAnnotation(from vehicle: Vehicle) -> VehicleAnnotation {
    return VehicleAnnotation(from: vehicle)
  }
}
