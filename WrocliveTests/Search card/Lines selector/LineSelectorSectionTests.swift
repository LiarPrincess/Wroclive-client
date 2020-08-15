// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

class LineSelectorSectionTests: XCTestCase {

  func test_noLines_noSections() {
    let lines = [Line]()
    let sections = LineSelectorSection.create(from: lines)
    XCTAssertEqual(sections, [])
  }

  func test_withLines_returnsSections() {
    let lines = LineSelectorSectionTests.lines
    let sections = LineSelectorSection.create(from: lines)
    let expected = LineSelectorSectionTests.sections
    XCTAssertEqual(sections, expected)
  }

  internal static let lines = LineSelectorSectionTests.data.lines
  internal static let sections = LineSelectorSectionTests.data.sections

  // swiftlint:disable:next closure_body_length
  private static var data: (lines: [Line], sections: [LineSelectorSection]) = {
    let line0 = Line(name: "0", type: .tram, subtype: .express)
    let line1 = Line(name: "1", type: .tram, subtype: .express)
    let line2 = Line(name: "2", type: .tram, subtype: .regular)
    let line3 = Line(name: "3", type: .bus, subtype: .regular)
    let line4 = Line(name: "4", type: .bus, subtype: .night)
    let line5 = Line(name: "5", type: .bus, subtype: .suburban)
    let line6 = Line(name: "6", type: .bus, subtype: .peakHour)
    let line7 = Line(name: "7", type: .bus, subtype: .zone)
    let line8 = Line(name: "8", type: .bus, subtype: .limited)
    let line9 = Line(name: "9", type: .bus, subtype: .temporary)

    // To make it more complicated reverse list
    let lines = [line0, line1, line2, line3, line4, line5, line6, line7, line8, line9].reversed()

    let sections = [
      LineSelectorSection(for: .express, lines: [line0, line1]),
      LineSelectorSection(for: .regular, lines: [line2, line3]),
      LineSelectorSection(for: .night, lines: [line4]),
      LineSelectorSection(for: .suburban, lines: [line5]),
      LineSelectorSection(for: .peakHour, lines: [line6]),
      LineSelectorSection(for: .zone, lines: [line7]),
      LineSelectorSection(for: .limited, lines: [line8]),
      LineSelectorSection(for: .temporary, lines: [line9])
    ]

    return (Array(lines), sections)
  }()
}
