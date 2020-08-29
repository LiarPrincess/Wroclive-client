// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

class LineSelectorSectionTests: XCTestCase {

  private typealias TestData = LineSelectorTestData

  func test_noLines_noSections() {
    let lines = [Line]()
    let sections = LineSelectorSection.create(from: lines)

    XCTAssertEqual(sections.tram, [])
    XCTAssertEqual(sections.bus, [])
  }

  func test_withLines_returnsSections() {
    let lines = TestData.lines
    let sections = LineSelectorSection.create(from: lines)

    XCTAssertEqual(sections.tram, TestData.tramSections)
    XCTAssertEqual(sections.bus, TestData.busSections)
  }
}
