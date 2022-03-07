// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
import WrocliveTestsShared
@testable import WrocliveFramework

extension MapViewModelTests {

  // swiftlint:disable:next function_body_length
  func test_getVehicleResponses_updateVehicles_orShowError() {
    self.viewModel = self.createViewModel()
    viewModel.viewDidLoad()

    XCTAssertTrue(self.vehicles.isEmpty)
    XCTAssertNil(self.apiErrorAlert)

    // In progress - no changes
    self.setVehicleResponse(.inProgress)
    XCTAssertTrue(self.vehicles.isEmpty)
    XCTAssertNil(self.apiErrorAlert)

    // Vehicles reponse 1
    let vehicles1 = self.dummyVehicles1
    self.setVehicleResponse(.data(vehicles1))
    XCTAssertEqual(self.vehicles, vehicles1)
    XCTAssertNil(self.apiErrorAlert)

    // Api general error
    let error = DummyError()
    self.setVehicleResponse(.error(.otherError(error)))
    XCTAssertEqual(self.vehicles, vehicles1) // Same positions!
    XCTAssertEqual(self.apiErrorAlert, .otherError(error))
    self.apiErrorAlert = nil // Reset

    // Api invalid response error - different error type
    self.setVehicleResponse(.error(.invalidResponse))
    XCTAssertEqual(self.vehicles, vehicles1)
    XCTAssertEqual(self.apiErrorAlert, .invalidResponse)
    self.apiErrorAlert = nil // Reset

    // Vehicles reponse 2
    self.setVehicleResponse(.inProgress)
    XCTAssertEqual(self.vehicles, vehicles1)
    XCTAssertNil(self.apiErrorAlert)

    let vehicles2 = self.dummyVehicles2
    self.setVehicleResponse(.data(vehicles2))
    XCTAssertEqual(self.vehicles, vehicles2)
    XCTAssertNil(self.apiErrorAlert)

    // Back to vehicles reponse 1
    self.setVehicleResponse(.inProgress)
    XCTAssertEqual(self.vehicles, vehicles2)
    XCTAssertNil(self.apiErrorAlert)

    self.setVehicleResponse(.data(vehicles1))
    XCTAssertEqual(self.vehicles, vehicles1)
    XCTAssertNil(self.apiErrorAlert)

    // Api no internet error
    self.setVehicleResponse(.error(.reachabilityError))
    XCTAssertEqual(self.vehicles, vehicles1)
    XCTAssertEqual(self.apiErrorAlert, .reachabilityError)
  }

  private var dummyVehicles1: [Vehicle] {
    let line = Line(name: "1", type: .tram, subtype: .regular)
    return [
      self.createVehicle(id: "0", line: line, num: 3.0),
      self.createVehicle(id: "1", line: line, num: 6.0),
      self.createVehicle(id: "2", line: line, num: 9.0)
    ]
  }

  private var dummyVehicles2: [Vehicle] {
    let line1 = Line(name: "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)

    return [
      self.createVehicle(id: "10", line: line1, num: 12.0),
      self.createVehicle(id: "11", line: line1, num: 15.0),
      self.createVehicle(id: "12", line: line1, num: 18.0),
      self.createVehicle(id: "20", line: line2, num: 21.0),
      self.createVehicle(id: "21", line: line2, num: 24.0),
      self.createVehicle(id: "22", line: line2, num: 27.0)
    ]
  }

  private func createVehicle(id: String, line: Line, num: Double) -> Vehicle {
    return Vehicle(id: id, line: line, latitude: num, longitude: num, angle: num)
  }
}
