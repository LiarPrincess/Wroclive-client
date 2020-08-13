// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

private typealias Constants = LineSelector.Constants.Cell

class LineSelectorCellTests: XCTestCase {

  func test_selectedCell_hasSelectedStyle() {
    let line = Line(name: "0l", type: .tram, subtype: .regular)
    let text = self.render(line: line, isSelected: true)

    XCTAssertEqual(
      text,
      NSAttributedString(string: "0L", attributes: Constants.selectedTextAttributes)
    )
  }

  func test_deselectedCell_hasDeselectedStyle() {
    let line = Line(name: "0l", type: .tram, subtype: .regular)
    let text = self.render(line: line, isSelected: false)

    XCTAssertEqual(
      text,
      NSAttributedString(string: "0L", attributes: Constants.notSelectedTextAttributes)
    )
  }

  private func render(line: Line,
                      isSelected: Bool) -> NSAttributedString {
    return LineSelectorCell.createText(line: line, isSelected: isSelected)
  }
}
