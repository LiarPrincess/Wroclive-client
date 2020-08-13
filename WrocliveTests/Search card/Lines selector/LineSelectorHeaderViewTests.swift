// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

private typealias Constants = LineSelector.Constants.Header

class LineSelectorHeaderViewTests: XCTestCase {

  var lineSubtypes: [LineSubtype] {
    return [.regular, .express, .peakHour, .suburban, .zone, .limited, .temporary, .night]
  }

  func test_sections_haveValidNames() {
    for lineSubtype in self.lineSubtypes {
      let section = LineSelectorSection(for: lineSubtype, lines: [])
      let text = LineSelectorHeaderView.createText(section: section)

      XCTAssertEqual(
        text,
        NSAttributedString(string: section.name, attributes: Constants.textAttributes)
      )
    }
  }
}
