// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
import WrocliveFramework

// MARK: - Line type

func XCTAssertAll(lines: [Line],
                  haveType type: LineType,
                  file: StaticString = #file,
                  line: UInt = #line) {
  for l in lines {
    XCTAssertEqual(l.type, type, file: file, line: line)
  }
}

// MARK: - Api error

func XCTAssertEqual(_ lhs: ApiError?,
                    _ rhs: ApiError,
                    file: StaticString = #file,
                    line: UInt = #line) {
  guard let l = lhs else {
    XCTAssertNotNil(lhs, file: file, line: line)
    return
  }

  XCTAssertEqual(l, rhs, file: file, line: line)
}

func XCTAssertEqual(_ lhs: ApiError,
                    _ rhs: ApiError,
                    file: StaticString = #file,
                    line: UInt = #line) {
  let lhsString = String(describing: lhs)
  let rhsString = String(describing: rhs)
  XCTAssertEqual(lhsString, rhsString, file: file, line: line)
}

// MARK: - CLLocationCoordinate2D

func XCTAssertEqual(_ lhs: CLLocationCoordinate2D,
                    _ rhs: CLLocationCoordinate2D,
                    file: StaticString = #file,
                    line: UInt = #line) {
  XCTAssertEqual(lhs.latitude, rhs.latitude, file: file, line: line)
  XCTAssertEqual(lhs.longitude, rhs.longitude, file: file, line: line)
}

// MARK: - Contains vehicle

func XCTAssertContains(_ vehicles: [Vehicle],
                       vehicle: Vehicle,
                       file: StaticString = #file,
                       line: UInt = #line) {
  let contains = vehicles.contains { isEqual($0, vehicle) }
  XCTAssert(contains, file: file, line: line)
}

private func isEqual(_ lhs: Vehicle, _ rhs: Vehicle) -> Bool {
  return lhs.id == rhs.id
    && lhs.line == rhs.line
    && lhs.latitude == rhs.latitude
    && lhs.longitude == rhs.longitude
    && lhs.angle == rhs.angle
}

// MARK: - Contains vehicle annotation

func XCTAssertContains(_ annotations: [VehicleAnnotation],
                       annotation: VehicleAnnotation,
                       file: StaticString = #file,
                       line: UInt = #line) {
  let contains = annotations.contains { isEqual($0, annotation) }
  XCTAssert(contains, file: file, line: line)
}

private func isEqual(_ lhs: VehicleAnnotation, _ rhs: VehicleAnnotation) -> Bool {
  return lhs.vehicleId == rhs.vehicleId
    && lhs.line == rhs.line
    && lhs.angle == rhs.angle
    && lhs.coordinate.latitude == rhs.coordinate.latitude
    && lhs.coordinate.longitude == rhs.coordinate.longitude
}

// MARK: - Contains vehicle annotation update

func XCTAssertContains(_ updates: [VehicleAnnotationDiff.Update],
                       item: VehicleAnnotationDiff.Update,
                       file: StaticString = #file,
                       line: UInt = #line) {
  let containsValue = updates.contains {
    isEqual($0.vehicle, item.vehicle) && isEqual($0.annotation, item.annotation)
  }

  XCTAssert(containsValue, file: file, line: line)
}
