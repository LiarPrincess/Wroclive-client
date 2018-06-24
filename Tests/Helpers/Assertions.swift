// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

typealias RecordedCLLocationCoordinate2DEvent = Recorded<Event<CLLocationCoordinate2D>>

func XCTAssertEqual(_ lhs: [RecordedCLLocationCoordinate2DEvent],
                    _ rhs: [RecordedCLLocationCoordinate2DEvent],
                    file: StaticString = #file,
                    line: UInt         = #line) {
  XCTAssertEqual(lhs.count, rhs.count, file: file, line: line)

  for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
    XCTAssertEqual(lhsEvent.time, rhsEvent.time, file: file, line: line)

    let lhsLocation = lhsEvent.value.element!
    let rhsLocation = rhsEvent.value.element!
    XCTAssertEqual(lhsLocation.latitude,  rhsLocation.latitude,  file: file, line: line)
    XCTAssertEqual(lhsLocation.longitude, rhsLocation.longitude, file: file, line: line)
  }
}

typealias VehicleEvent = Recorded<Event<[Vehicle]>>

func XCTAssertEqual(_ lhs: [VehicleEvent], _ rhs: [VehicleEvent], file: StaticString = #file, line: UInt = #line) {
  XCTAssertEqual(lhs.count, rhs.count, file: file, line: line)

  for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
    XCTAssertEqual(lhsEvent.time, rhsEvent.time, file: file, line: line)

    for (lhsVehicle, rhsVehicle) in zip(lhsEvent.value.element!, rhsEvent.value.element!) {
      XCTAssertEqual(lhsVehicle.id, rhsVehicle.id)
      XCTAssertEqual(lhsVehicle.line, rhsVehicle.line)
      XCTAssertEqual(lhsVehicle.angle, rhsVehicle.angle, accuracy: 0.1)
      XCTAssertEqual(lhsVehicle.latitude, rhsVehicle.latitude, accuracy: 0.1)
      XCTAssertEqual(lhsVehicle.longitude, rhsVehicle.longitude, accuracy: 0.1)
    }
  }
}

func XCTAssertContains(_ annotations: [VehicleAnnotation], item: VehicleAnnotation, file: StaticString = #file, line: UInt = #line) {
  let containsValue = annotations.contains { isEqual($0, item) }
  XCTAssert(containsValue, file: file, line: line)
}

private func isEqual(_ lhs: VehicleAnnotation, _ rhs: VehicleAnnotation) -> Bool {
  return lhs.vehicleId  == rhs.vehicleId
    && lhs.line       == rhs.line
    && lhs.angle      == rhs.angle
    && abs(lhs.coordinate.latitude  - rhs.coordinate.latitude)  < 0.1
    && abs(lhs.coordinate.longitude - rhs.coordinate.longitude) < 0.1
}

typealias AnnotationAssignment = VehicleAnnotationUpdates.AnnotationAssignment

func XCTAssertContains(_ assignments: [AnnotationAssignment], item: AnnotationAssignment, file: StaticString = #file, line: UInt = #line) {
  let containsValue = assignments.contains {
    isEqual($0.vehicle, item.vehicle) && isEqual($0.annotation, item.annotation)
  }

  XCTAssert(containsValue, file: file, line: line)
}

private func isEqual(_ lhs: Vehicle, _ rhs: Vehicle) -> Bool {
  return lhs.id   == rhs.id
    && lhs.line == rhs.line
    && abs(lhs.latitude  - rhs.latitude)  < 0.1
    && abs(lhs.longitude - rhs.longitude) < 0.1
    && abs(lhs.angle     - rhs.angle)     < 0.1
}
