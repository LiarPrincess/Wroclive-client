//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
@testable import Wroclive

private typealias TextStyles = BookmarksCellConstants.TextStyles

final class BookmarksCellViewModelTests: XCTestCase {

  func test_bookmark_withoutLines_showsJustName() {
    let bookmark  = Bookmark(name: "name", lines: [])
    let viewModel = BookmarkCellViewModel(bookmark)

    XCTAssertEqual(viewModel.name,  NSAttributedString(string: "name", attributes: TextStyles.name))
    XCTAssertEqual(viewModel.lines, NSAttributedString(string: "",     attributes: TextStyles.lines))
  }

  func test_bookmark_withSingleTram_showsSingleTramLine() {
    let tram1     = Line(name: "1", type: .tram, subtype: .regular)
    let bookmark  = Bookmark(name: "name", lines: [tram1])
    let viewModel = BookmarkCellViewModel(bookmark)

    XCTAssertEqual(viewModel.name,  NSAttributedString(string: "name", attributes: TextStyles.name))
    XCTAssertEqual(viewModel.lines, NSAttributedString(string: "1",    attributes: TextStyles.lines))
  }

  func test_bookmark_withSingleBus_showsSingleBusLine() {
    let bus1 = Line(name: "A", type: .bus, subtype: .regular)
    let bookmark  = Bookmark(name: "name", lines: [bus1])
    let viewModel = BookmarkCellViewModel(bookmark)

    XCTAssertEqual(viewModel.name,  NSAttributedString(string: "name", attributes: TextStyles.name))
    XCTAssertEqual(viewModel.lines, NSAttributedString(string: "A",     attributes: TextStyles.lines))
  }

  func test_bookmark_withMultipleLines_showsSortedLines() {
    let tram1 = Line(name: "1", type: .tram, subtype: .regular)
    let tram2 = Line(name: "2", type: .tram, subtype: .regular)

    let bus1 = Line(name: "A", type: .bus, subtype: .regular)
    let bus2 = Line(name: "B", type: .bus, subtype: .regular)
    let bus3 = Line(name: "C", type: .bus, subtype: .regular)

    // changer order, so we also test sorting
    let bookmark  = Bookmark(name: "name", lines: [tram2, tram1, bus3, bus2, bus1])
    let viewModel = BookmarkCellViewModel(bookmark)

    XCTAssertEqual(viewModel.name,  NSAttributedString(string: "name",         attributes: TextStyles.name))
    XCTAssertEqual(viewModel.lines, NSAttributedString(string: "1   2\nA   B   C", attributes: TextStyles.lines))
  }
}
