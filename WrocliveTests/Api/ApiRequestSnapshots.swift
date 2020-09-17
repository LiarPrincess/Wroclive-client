// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
import SnapshotTesting
@testable import WrocliveFramework

private typealias Constants = CardContainer.Constants

class ApiRequestSnapshots: XCTestCase, SnapshotTestCase, ApiTestCase {

  // MARK: - Lines

  func test_lines() {
    let api = self.createApi(baseUrl: "API_URL") { request in
      self.assertSnapshot(matching: request, as: .raw)
      throw DummyApiError()
    }

    let expectation = XCTestExpectation(description: "response")
    _ = api.getLines().catch { _ in
      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }

  // MARK: - Vehicle locations

  func test_vehicleLocations_1() {
    let api = self.createApi(baseUrl: "API_URL") { request in
      self.assertSnapshot(matching: request, as: .raw)
      throw DummyApiError()
    }

    let lines = [
      Line(name: "A", type: .bus, subtype: .express),
      Line(name: "4", type: .tram, subtype: .express)
    ]

    let expectation = XCTestExpectation(description: "response")
    _ = api.getVehicleLocations(for: lines).catch { _ in
      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }

  func test_vehicleLocations_2() {
    let api = self.createApi(baseUrl: "API_URL") { request in
      self.assertSnapshot(matching: request, as: .raw)
      throw DummyApiError()
    }

    let lines = [
      Line(name: "A", type: .bus, subtype: .express),
      Line(name: "D", type: .bus, subtype: .express),
      Line(name: "0P", type: .tram, subtype: .regular),
      Line(name: "0L", type: .tram, subtype: .regular),
      Line(name: "4", type: .tram, subtype: .regular),
      Line(name: "20", type: .tram, subtype: .regular),
      Line(name: "31", type: .tram, subtype: .regular),
      Line(name: "32", type: .tram, subtype: .regular),
      Line(name: "107", type: .bus, subtype: .regular),
      Line(name: "124", type: .bus, subtype: .regular),
      Line(name: "125", type: .bus, subtype: .regular),
      Line(name: "250", type: .bus, subtype: .night),
      Line(name: "251", type: .bus, subtype: .night),
      Line(name: "325", type: .bus, subtype: .regular),
      Line(name: "602", type: .bus, subtype: .suburban),
      Line(name: "607", type: .bus, subtype: .suburban)
    ]

    let expectation = XCTestExpectation(description: "response")
    _ = api.getVehicleLocations(for: lines).catch { _ in
      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }
}
