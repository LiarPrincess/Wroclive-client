// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
import Result
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

private typealias Defaults = MapViewControllerConstants.Defaults

class MapViewModelVehiclesTests: MapViewModelTestsBase {

  /**
   Steps:
   100 View did appear
   200 Vehicles reponse 1
   300 Api general error
   400 Api invalid response error
   500 Vehicles reponse 2
   600 Api no internet error
   */
  func test_responses_updateVehicles_orShowError() {
    let vehicles1 = self.vehicles1
    let vehicles2 = self.vehicles2

    self.mockViewDidAppearEvent(at: 100)
    self.mockVehicleResponseEvents(
      VehicleResponseEvent(200, vehicles1),
      VehicleResponseEvent(300, .generalError),
      VehicleResponseEvent(400, .invalidResponse),
      VehicleResponseEvent(500, vehicles2),
      VehicleResponseEvent(600, .noInternet)
    )

    self.startScheduler()

    XCTAssertEqual(self.vehiclesObserver.events, [
      next(200, vehicles1),
      next(500, vehicles2)
    ])

    XCTAssertEqual(self.showAlertObserver.events, [
      next(300, .apiError(error: .generalError)),
      next(400, .apiError(error: .invalidResponse)),
      next(600, .apiError(error: .noInternet))
    ])

    self.liveManager.assertOperationCount(vehicles: 1)
    self.liveManager.assertOperationCount(startTracking: 0, resumeTracking: 0, pauseTracking: 0)
  }

  private var vehicles1: [Vehicle] {
    let line = Line(name:  "1", type: .tram, subtype: .regular)
    return [
      createVehicle(id: "0", line: line, num: 3.0),
      createVehicle(id: "1", line: line, num: 6.0),
      createVehicle(id: "2", line: line, num: 9.0)
    ]
  }

  private var vehicles2: [Vehicle] {
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)

    return [
      createVehicle(id: "10", line: line1, num: 12.0),
      createVehicle(id: "11", line: line1, num: 15.0),
      createVehicle(id: "12", line: line1, num: 18.0),
      createVehicle(id: "20", line: line2, num: 21.0),
      createVehicle(id: "21", line: line2, num: 24.0),
      createVehicle(id: "22", line: line2, num: 27.0)
    ]
  }

  private func createVehicle(id: String, line: Line, num: Double) -> Vehicle {
    return Vehicle(id: id, line: line, latitude: num, longitude: num, angle: num)
  }
}