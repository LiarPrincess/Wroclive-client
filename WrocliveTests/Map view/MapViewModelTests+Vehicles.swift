// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
@testable import WrocliveFramework

extension MapViewModelTests {

  /// Steps:
  /// 1. In progress - no changes
  /// 2. Vehicles reponse 1
  /// 3. Api general error
  /// 4. Api invalid response error
  /// 5. In progress - no changes
  /// 6. Vehicles reponse 2
  /// 7. Api no internet error
  ///
  /// This has to be in a single sequence (and not in separate func),
  /// to test interactions between new states.
  func test_getVehicleResponses_updateVehicles_orShowError() {
    self.viewModel = self.createViewModel()
    XCTAssertTrue(self.vehicles.isEmpty)
    XCTAssertNil(self.isShowingApiErrorAlert)

    self.setVehicleResponse(.inProgress)
    XCTAssertTrue(self.vehicles.isEmpty)
    XCTAssertNil(self.isShowingApiErrorAlert)

    let vehicles1 = self.dummyVehicles1
    self.setVehicleResponse(.data(vehicles1))
    XCTAssertEqual(self.vehicles, vehicles1)
    XCTAssertNil(self.isShowingApiErrorAlert)

    let error = DummyError()
    self.setVehicleResponse(.error(.otherError(error)))
    XCTAssertEqual(self.vehicles, vehicles1) // Same positions!
    XCTAssertEqual(self.isShowingApiErrorAlert, .otherError(error))
    self.isShowingApiErrorAlert = nil // Reset

    self.setVehicleResponse(.error(.invalidResponse))
    XCTAssertEqual(self.vehicles, vehicles1)
    XCTAssertEqual(self.isShowingApiErrorAlert, .invalidResponse)
    self.isShowingApiErrorAlert = nil // Reset

    self.setVehicleResponse(.inProgress)
    XCTAssertEqual(self.vehicles, vehicles1)
    XCTAssertNil(self.isShowingApiErrorAlert)

    let vehicles2 = self.dummyVehicles2
    self.setVehicleResponse(.data(vehicles2))
    XCTAssertEqual(self.vehicles, vehicles2)
    XCTAssertNil(self.isShowingApiErrorAlert)

    self.setVehicleResponse(.error(.reachabilityError))
    XCTAssertEqual(self.vehicles, vehicles2)
    XCTAssertEqual(self.isShowingApiErrorAlert, .reachabilityError)
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
