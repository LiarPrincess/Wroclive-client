// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
@testable import WrocliveFramework

// swiftlint:disable force_unwrapping
// swiftlint:disable number_separator
// swiftlint:disable line_length
// swiftlint:disable function_body_length

class ApiVehicleLocationsResponseTests: XCTestCase, SnapshotTestCase, ApiTestCase {

  // MARK: - Single line

  func test_vehicles_singleLine() {
    let response = """
{
"timestamp": "2020-09-17T13:08:23.909Z",
"data": [
  {
    "line": { "type": "Tram", "name": "20", "subtype": "Regular" },
    "vehicles": [
      { "id": "16245155", "lat": 51.11504, "lng": 17.002327, "angle": 139.04539764300523 },
      { "id": "16245055", "lat": 51.140972, "lng": 16.912336, "angle": 101.82972374936128 },
      { "id": "16244470", "lat": 51.09403, "lng": 17.02096, "angle": -144.90427013151816 },
      { "id": "16245189", "lat": 51.092384, "lng": 16.977676, "angle": 15.773915996918163 },
      { "id": "16244763", "lat": 51.142914, "lng": 16.897179, "angle": -78.97396181751361 },
      { "id": "16245173", "lat": 51.12448, "lng": 16.985865, "angle": 114.52839136432385 },
      { "id": "16243875", "lat": 51.108593, "lng": 17.027336, "angle": 112.2424013208041 },
      { "id": "16244941", "lat": 51.117695, "lng": 16.99922, "angle": -31.70847902089531 },
      { "id": "16244802", "lat": 51.0841, "lng": 16.972288, "angle": 0 },
      { "id": "16244511", "lat": 51.0907, "lng": 17.017105, "angle": 36.60540762776509 },
      { "id": "16244480", "lat": 51.09769, "lng": 17.025345, "angle": -145.27787975960052 },
      { "id": "16245017", "lat": 51.138206, "lng": 16.93242, "angle": -82.85760577272202 }
    ]
  }
]
}
"""

    let api = self.createApi(baseUrl: "API_URL") { _ in
      let data = response.data(using: .utf8)!
      return (HTTPURLResponse(), data)
    }

    let line = Line(name: "20", type: .tram, subtype: .regular)
    let expectation = XCTestExpectation(description: "response")

    _ = api.getVehicleLocations(for: [line]).done { vehicles in
      let vehiclesSorted = vehicles.sorted { $0.id < $1.id }
      XCTAssertEqual(vehiclesSorted, [
        Vehicle(id: "16243875", line: line, latitude: 51.108593, longitude: 17.027336, angle: 112.2424013208041),
        Vehicle(id: "16244470", line: line, latitude: 51.09403, longitude: 17.02096, angle: -144.90427013151816),
        Vehicle(id: "16244480", line: line, latitude: 51.09769, longitude: 17.025345, angle: -145.27787975960052),
        Vehicle(id: "16244511", line: line, latitude: 51.0907, longitude: 17.017105, angle: 36.60540762776509),
        Vehicle(id: "16244763", line: line, latitude: 51.142914, longitude: 16.897179, angle: -78.97396181751361),
        Vehicle(id: "16244802", line: line, latitude: 51.0841, longitude: 16.972288, angle: 0),
        Vehicle(id: "16244941", line: line, latitude: 51.117695, longitude: 16.99922, angle: -31.70847902089531),
        Vehicle(id: "16245017", line: line, latitude: 51.138206, longitude: 16.93242, angle: -82.85760577272202),
        Vehicle(id: "16245055", line: line, latitude: 51.140972, longitude: 16.912336, angle: 101.82972374936128),
        Vehicle(id: "16245155", line: line, latitude: 51.11504, longitude: 17.002327, angle: 139.04539764300523),
        Vehicle(id: "16245173", line: line, latitude: 51.12448, longitude: 16.985865, angle: 114.52839136432385),
        Vehicle(id: "16245189", line: line, latitude: 51.092384, longitude: 16.977676, angle: 15.773915996918163)
      ])

      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }

  // MARK: - Multiple lines

  func test_vehicles_multipleLines() {
    let response = """
{
"timestamp": "2020-09-17T13:08:23.909Z",
"data": [
  {
    "line": { "type": "Tram", "name": "20", "subtype": "Regular" },
    "vehicles": [
      { "id": "16245155", "lat": 51.11504, "lng": 17.002327, "angle": 139.04539764300523 },
      { "id": "16245055", "lat": 51.140972, "lng": 16.912336, "angle": 101.82972374936128 }
    ]
  },
  {
    "line": { "subtype": "Express", "type": "Bus", "name": "A" },
    "vehicles": [
      { "id": "16230042", "lat": 51.08978, "lng": 16.976667, "angle": -164.82619668166825 },
      { "id": "16230023", "lat": 51.08144, "lng": 16.968155, "angle": 36.97540306017618 }
    ]
  },
  {
    "line": { "name": "125", "subtype": "Regular", "type": "Bus" },
    "vehicles": [
      { "id": "16226930", "lat": 51.09033, "lng": 16.976862, "angle": -163.75821830447848 },
      { "id": "16227002", "lat": 51.09383, "lng": 16.998674, "angle": -80.90615300046392 }
    ]
  },
  {
    "line": { "name": "612", "type": "Bus", "subtype": "Suburban" },
    "vehicles": [
      { "id": "16225667", "lat": 51.09939, "lng": 17.035099, "angle": 0 },
      { "id": "16225743", "lat": 51.056633, "lng": 17.022263, "angle": 18.046254719214403 }
    ]
  },
  {
    "line": { "name": "701", "type": "Bus", "subtype": "Temporary" },
    "vehicles": [
      { "id": "16229766", "lat": 51.106995, "lng": 17.07308, "angle": 128.7532384254821 },
      { "id": "16229815", "lat": 51.105785, "lng": 17.07685, "angle": -61.88612931993907 }
    ]
  }
]
}
"""

    let api = self.createApi(baseUrl: "API_URL") { _ in
      let data = response.data(using: .utf8)!
      return (HTTPURLResponse(), data)
    }

    let line20 = Line(name: "20", type: .tram, subtype: .regular)
    let lineA = Line(name: "A", type: .bus, subtype: .express)
    let line125 = Line(name: "125", type: .bus, subtype: .regular)
    let line612 = Line(name: "612", type: .bus, subtype: .suburban)
    let line701 = Line(name: "701", type: .bus, subtype: .temporary)
    let lines = [line20, lineA, line125, line612, line701]
    let expectation = XCTestExpectation(description: "response")

    _ = api.getVehicleLocations(for: lines).done { vehicles in
      let vehiclesSorted = vehicles.sorted { $0.id < $1.id }
      XCTAssertEqual(vehiclesSorted, [
        Vehicle(id: "16225667", line: line612, latitude: 51.09939, longitude: 17.035099, angle: 0),
        Vehicle(id: "16225743", line: line612, latitude: 51.056633, longitude: 17.022263, angle: 18.046254719214403),
        Vehicle(id: "16226930", line: line125, latitude: 51.09033, longitude: 16.976862, angle: -163.75821830447848),
        Vehicle(id: "16227002", line: line125, latitude: 51.09383, longitude: 16.998674, angle: -80.90615300046392),
        Vehicle(id: "16229766", line: line701, latitude: 51.106995, longitude: 17.07308, angle: 128.7532384254821),
        Vehicle(id: "16229815", line: line701, latitude: 51.105785, longitude: 17.07685, angle: -61.88612931993907),
        Vehicle(id: "16230023", line: lineA, latitude: 51.08144, longitude: 16.968155, angle: 36.97540306017618),
        Vehicle(id: "16230042", line: lineA, latitude: 51.08978, longitude: 16.976667, angle: -164.82619668166825),
        Vehicle(id: "16245055", line: line20, latitude: 51.140972, longitude: 16.912336, angle: 101.82972374936128),
        Vehicle(id: "16245155", line: line20, latitude: 51.11504, longitude: 17.002327, angle: 139.04539764300523)
      ])

      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }
}
