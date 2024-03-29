// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
import WrocliveTestsShared
@testable import WrocliveFramework

// swiftlint:disable force_unwrapping
// swiftlint:disable closure_body_length
// swiftlint:disable function_body_length
// swiftlint:disable file_length

class ApiLinesResponseTests: XCTestCase, ApiTestCase {

  func test_single() {
    let response = """
{
  "timestamp": "2020-09-17T01:00:27.506Z",
  "data": [
    { "name": "A", "subtype": "Express", "type": "Bus" },
  ]
}
"""

    let api = self.createApi(baseUrl: "API_URL") { _ in
      let data = response.data(using: .utf8)!
      return (HTTPURLResponse(), data)
    }

    let expectation = XCTestExpectation(description: "response")
    _ = api.getLines().done { lines in
        let linesSorted = lines.sorted { $0.name < $1.name }
        XCTAssertEqual(linesSorted, [
          Line(name: "A", type: .bus, subtype: .express)
        ])

      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }

  func test_partial_success() {
    let response = """
  {
    "timestamp": "2020-09-17T01:00:27.506Z",
    "data": [
      { "subtype": "Regular", "type": "Tram", "name": "0L" },
      { "subtype": "Regular", "type": "Tram", "name": "0P" },
      { "type": "Tram", "subtype": "INVALID_SUBTYPE", "name": "1" },
      { "name": "10", "subtype": "Regular", "type": "Tram" },
      { "type": "INVALID_TYPE", "name": "11", "subtype": "Regular" },
      { "subtype": "Regular", "type": "Tram", "name": "15" }
    ]
  }
"""

    let api = self.createApi(baseUrl: "API_URL") { _ in
      let data = response.data(using: .utf8)!
      return (HTTPURLResponse(), data)
    }

    let expectation = XCTestExpectation(description: "response")
    _ = api.getLines().done { lines in
        let linesSorted = lines.sorted { $0.name < $1.name }
        XCTAssertEqual(linesSorted, [
          Line(name: "0L", type: .tram, subtype: .regular),
          Line(name: "0P", type: .tram, subtype: .regular),
          Line(name: "10", type: .tram, subtype: .regular),
          Line(name: "15", type: .tram, subtype: .regular)
        ])

      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }

  func test_full() {
    let response = """
{
  "timestamp": "2020-09-17T01:00:27.506Z",
  "data": [
    { "subtype": "Regular", "type": "Tram", "name": "0L" },
    { "subtype": "Regular", "type": "Tram", "name": "0P" },
    { "type": "Tram", "subtype": "Regular", "name": "1" },
    { "name": "10", "subtype": "Regular", "type": "Tram" },
    { "type": "Tram", "name": "11", "subtype": "Regular" },
    { "subtype": "Regular", "type": "Tram", "name": "15" },
    { "name": "16", "subtype": "Regular", "type": "Tram" },
    { "name": "17", "type": "Tram", "subtype": "Regular" },
    { "type": "Tram", "subtype": "Regular", "name": "2" },
    { "type": "Tram", "name": "20", "subtype": "Regular" },
    { "type": "Tram", "name": "23", "subtype": "Regular" },
    { "subtype": "Regular", "name": "3", "type": "Tram" },
    { "subtype": "Regular", "type": "Tram", "name": "31" },
    { "name": "32", "type": "Tram", "subtype": "Regular" },
    { "type": "Tram", "subtype": "Regular", "name": "33" },
    { "subtype": "Regular", "name": "4", "type": "Tram" },
    { "subtype": "Regular", "name": "5", "type": "Tram" },
    { "name": "6", "subtype": "Regular", "type": "Tram" },
    { "name": "7", "subtype": "Regular", "type": "Tram" },
    { "name": "74", "type": "Tram", "subtype": "Regular" },
    { "type": "Tram", "subtype": "Regular", "name": "8" },
    { "subtype": "Regular", "type": "Tram", "name": "9" },
    { "name": "100", "subtype": "Regular", "type": "Bus" },
    { "subtype": "Regular", "type": "Bus", "name": "101" },
    { "type": "Bus", "subtype": "Regular", "name": "102" },
    { "subtype": "Regular", "type": "Bus", "name": "103" },
    { "type": "Bus", "name": "104", "subtype": "Regular" },
    { "subtype": "Regular", "name": "105", "type": "Bus" },
    { "type": "Bus", "name": "106", "subtype": "Regular" },
    { "type": "Bus", "subtype": "Regular", "name": "107" },
    { "type": "Bus", "name": "108", "subtype": "Regular" },
    { "name": "109", "subtype": "Regular", "type": "Bus" },
    { "name": "110", "subtype": "Regular", "type": "Bus" },
    { "type": "Bus", "subtype": "Regular", "name": "111" },
    { "name": "112", "subtype": "Regular", "type": "Bus" },
    { "name": "113", "type": "Bus", "subtype": "Regular" },
    { "name": "114", "subtype": "Regular", "type": "Bus" },
    { "name": "115", "type": "Bus", "subtype": "Regular" },
    { "name": "116", "type": "Bus", "subtype": "Regular" },
    { "name": "118", "subtype": "Regular", "type": "Bus" },
    { "name": "119", "subtype": "Regular", "type": "Bus" },
    { "name": "120", "subtype": "Regular", "type": "Bus" },
    { "name": "121", "type": "Bus", "subtype": "Regular" },
    { "name": "122", "subtype": "Regular", "type": "Bus" },
    { "name": "124", "subtype": "Regular", "type": "Bus" },
    { "name": "125", "subtype": "Regular", "type": "Bus" },
    { "name": "126", "subtype": "Regular", "type": "Bus" },
    { "type": "Bus", "name": "127", "subtype": "Regular" },
    { "name": "128", "subtype": "Regular", "type": "Bus" },
    { "type": "Bus", "name": "129", "subtype": "Regular" },
    { "subtype": "Regular", "type": "Bus", "name": "130" },
    { "subtype": "Regular", "name": "131", "type": "Bus" },
    { "subtype": "Regular", "name": "132", "type": "Bus" },
    { "name": "133", "subtype": "Regular", "type": "Bus" },
    { "type": "Bus", "name": "134", "subtype": "Regular" },
    { "subtype": "Regular", "name": "136", "type": "Bus" },
    { "name": "140", "subtype": "Regular", "type": "Bus" },
    { "name": "141", "subtype": "Regular", "type": "Bus" },
    { "subtype": "Regular", "name": "142", "type": "Bus" },
    { "name": "143", "subtype": "Regular", "type": "Bus" },
    { "name": "144", "type": "Bus", "subtype": "Regular" },
    { "type": "Bus", "name": "145", "subtype": "Regular" },
    { "type": "Bus", "name": "146", "subtype": "Regular" },
    { "name": "147", "subtype": "Regular", "type": "Bus" },
    { "name": "148", "type": "Bus", "subtype": "Regular" },
    { "subtype": "Regular", "name": "149", "type": "Bus" },
    { "type": "Bus", "name": "150", "subtype": "Regular" },
    { "subtype": "Regular", "type": "Bus", "name": "151" },
    { "name": "206", "subtype": "Night", "type": "Bus" },
    { "name": "240", "subtype": "Night", "type": "Bus" },
    { "name": "241", "subtype": "Night", "type": "Bus" },
    { "subtype": "Night", "type": "Bus", "name": "242" },
    { "name": "243", "type": "Bus", "subtype": "Night" },
    { "name": "245", "type": "Bus", "subtype": "Night" },
    { "name": "246", "subtype": "Night", "type": "Bus" },
    { "name": "247", "subtype": "Night", "type": "Bus" },
    { "name": "248", "subtype": "Night", "type": "Bus" },
    { "type": "Bus", "subtype": "Night", "name": "249" },
    { "type": "Bus", "subtype": "Night", "name": "250" },
    { "name": "251", "subtype": "Night", "type": "Bus" },
    { "subtype": "Night", "name": "253", "type": "Bus" },
    { "name": "255", "type": "Bus", "subtype": "Night" },
    { "name": "257", "subtype": "Night", "type": "Bus" },
    { "type": "Bus", "name": "259", "subtype": "Night" },
    { "name": "319", "subtype": "Regular", "type": "Bus" },
    { "name": "325", "subtype": "Regular", "type": "Bus" },
    { "subtype": "Suburban", "name": "602", "type": "Bus" },
    { "name": "607", "subtype": "Suburban", "type": "Bus" },
    { "type": "Bus", "subtype": "Suburban", "name": "609" },
    { "name": "612", "type": "Bus", "subtype": "Suburban" },
    { "name": "701", "type": "Bus", "subtype": "Temporary" },
    { "name": "714", "type": "Bus", "subtype": "Temporary" },
    { "type": "Bus", "subtype": "Temporary", "name": "715" },
    { "subtype": "Express", "type": "Bus", "name": "A" },
    { "name": "C", "subtype": "Express", "type": "Bus" },
    { "subtype": "Express", "type": "Bus", "name": "D" },
    { "name": "K", "type": "Bus", "subtype": "Express" },
    { "subtype": "Express", "name": "N", "type": "Bus" }
  ]
}
"""

    let api = self.createApi(baseUrl: "API_URL") { _ in
      let data = response.data(using: .utf8)!
      return (HTTPURLResponse(), data)
    }

    let expectation = XCTestExpectation(description: "response")
    _ = api.getLines().done { lines in
      let linesSorted = lines.sorted { $0.name < $1.name }
      XCTAssertEqual(linesSorted, [
        Line(name: "0L", type: .tram, subtype: .regular),
        Line(name: "0P", type: .tram, subtype: .regular),
        Line(name: "1", type: .tram, subtype: .regular),
        Line(name: "10", type: .tram, subtype: .regular),
        Line(name: "100", type: .bus, subtype: .regular),
        Line(name: "101", type: .bus, subtype: .regular),
        Line(name: "102", type: .bus, subtype: .regular),
        Line(name: "103", type: .bus, subtype: .regular),
        Line(name: "104", type: .bus, subtype: .regular),
        Line(name: "105", type: .bus, subtype: .regular),
        Line(name: "106", type: .bus, subtype: .regular),
        Line(name: "107", type: .bus, subtype: .regular),
        Line(name: "108", type: .bus, subtype: .regular),
        Line(name: "109", type: .bus, subtype: .regular),
        Line(name: "11", type: .tram, subtype: .regular),
        Line(name: "110", type: .bus, subtype: .regular),
        Line(name: "111", type: .bus, subtype: .regular),
        Line(name: "112", type: .bus, subtype: .regular),
        Line(name: "113", type: .bus, subtype: .regular),
        Line(name: "114", type: .bus, subtype: .regular),
        Line(name: "115", type: .bus, subtype: .regular),
        Line(name: "116", type: .bus, subtype: .regular),
        Line(name: "118", type: .bus, subtype: .regular),
        Line(name: "119", type: .bus, subtype: .regular),
        Line(name: "120", type: .bus, subtype: .regular),
        Line(name: "121", type: .bus, subtype: .regular),
        Line(name: "122", type: .bus, subtype: .regular),
        Line(name: "124", type: .bus, subtype: .regular),
        Line(name: "125", type: .bus, subtype: .regular),
        Line(name: "126", type: .bus, subtype: .regular),
        Line(name: "127", type: .bus, subtype: .regular),
        Line(name: "128", type: .bus, subtype: .regular),
        Line(name: "129", type: .bus, subtype: .regular),
        Line(name: "130", type: .bus, subtype: .regular),
        Line(name: "131", type: .bus, subtype: .regular),
        Line(name: "132", type: .bus, subtype: .regular),
        Line(name: "133", type: .bus, subtype: .regular),
        Line(name: "134", type: .bus, subtype: .regular),
        Line(name: "136", type: .bus, subtype: .regular),
        Line(name: "140", type: .bus, subtype: .regular),
        Line(name: "141", type: .bus, subtype: .regular),
        Line(name: "142", type: .bus, subtype: .regular),
        Line(name: "143", type: .bus, subtype: .regular),
        Line(name: "144", type: .bus, subtype: .regular),
        Line(name: "145", type: .bus, subtype: .regular),
        Line(name: "146", type: .bus, subtype: .regular),
        Line(name: "147", type: .bus, subtype: .regular),
        Line(name: "148", type: .bus, subtype: .regular),
        Line(name: "149", type: .bus, subtype: .regular),
        Line(name: "15", type: .tram, subtype: .regular),
        Line(name: "150", type: .bus, subtype: .regular),
        Line(name: "151", type: .bus, subtype: .regular),
        Line(name: "16", type: .tram, subtype: .regular),
        Line(name: "17", type: .tram, subtype: .regular),
        Line(name: "2", type: .tram, subtype: .regular),
        Line(name: "20", type: .tram, subtype: .regular),
        Line(name: "206", type: .bus, subtype: .night),
        Line(name: "23", type: .tram, subtype: .regular),
        Line(name: "240", type: .bus, subtype: .night),
        Line(name: "241", type: .bus, subtype: .night),
        Line(name: "242", type: .bus, subtype: .night),
        Line(name: "243", type: .bus, subtype: .night),
        Line(name: "245", type: .bus, subtype: .night),
        Line(name: "246", type: .bus, subtype: .night),
        Line(name: "247", type: .bus, subtype: .night),
        Line(name: "248", type: .bus, subtype: .night),
        Line(name: "249", type: .bus, subtype: .night),
        Line(name: "250", type: .bus, subtype: .night),
        Line(name: "251", type: .bus, subtype: .night),
        Line(name: "253", type: .bus, subtype: .night),
        Line(name: "255", type: .bus, subtype: .night),
        Line(name: "257", type: .bus, subtype: .night),
        Line(name: "259", type: .bus, subtype: .night),
        Line(name: "3", type: .tram, subtype: .regular),
        Line(name: "31", type: .tram, subtype: .regular),
        Line(name: "319", type: .bus, subtype: .regular),
        Line(name: "32", type: .tram, subtype: .regular),
        Line(name: "325", type: .bus, subtype: .regular),
        Line(name: "33", type: .tram, subtype: .regular),
        Line(name: "4", type: .tram, subtype: .regular),
        Line(name: "5", type: .tram, subtype: .regular),
        Line(name: "6", type: .tram, subtype: .regular),
        Line(name: "602", type: .bus, subtype: .suburban),
        Line(name: "607", type: .bus, subtype: .suburban),
        Line(name: "609", type: .bus, subtype: .suburban),
        Line(name: "612", type: .bus, subtype: .suburban),
        Line(name: "7", type: .tram, subtype: .regular),
        Line(name: "701", type: .bus, subtype: .temporary),
        Line(name: "714", type: .bus, subtype: .temporary),
        Line(name: "715", type: .bus, subtype: .temporary),
        Line(name: "74", type: .tram, subtype: .regular),
        Line(name: "8", type: .tram, subtype: .regular),
        Line(name: "9", type: .tram, subtype: .regular),
        Line(name: "A", type: .bus, subtype: .express),
        Line(name: "C", type: .bus, subtype: .express),
        Line(name: "D", type: .bus, subtype: .express),
        Line(name: "K", type: .bus, subtype: .express),
        Line(name: "N", type: .bus, subtype: .express)
      ])

      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }
}
