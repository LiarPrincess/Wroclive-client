//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
@testable import Wroclive

private typealias Layout     = BookmarksCellConstants.Layout
private typealias TextStyles = BookmarksCellConstants.TextStyles

class BookmarksCellViewModelTests: XCTestCase {

  func test_bookmark_withoutLines_showsJustName() {
    let bookmark  = Bookmark(name: "name", lines: [])
    let viewModel = BookmarkCellViewModel(bookmark)

    XCTAssertEqual(viewModel.name,  NSAttributedString(string: bookmark.name, attributes: TextStyles.name))
    XCTAssertEqual(viewModel.lines, NSAttributedString(string: "",            attributes: TextStyles.lines))
  }

  func test_bookmark_withOnlyTrams_showsSingleTramLine() {
    let tram1 = Line(name: "1", type: .tram, subtype: .regular)
    let tram2 = Line(name: "2", type: .tram, subtype: .regular)
    let tram3 = Line(name: "3", type: .tram, subtype: .regular)

    let bookmark  = Bookmark(name: "name", lines: [tram1, tram2, tram3])
    let viewModel = BookmarkCellViewModel(bookmark)

    let spacing = Layout.LinesLabel.horizontalSpacing
    let caption = bookmark.lines.map { $0.name }.joined(separator: spacing)

    XCTAssertEqual(viewModel.name,  NSAttributedString(string: bookmark.name, attributes: TextStyles.name))
    XCTAssertEqual(viewModel.lines, NSAttributedString(string: caption,       attributes: TextStyles.lines))
  }

  func test_bookmark_withOnlyBuses_showsSingleBusLine() {
    let bus1 = Line(name: "A", type: .bus, subtype: .regular)
    let bus2 = Line(name: "B", type: .bus, subtype: .regular)
    let bus3 = Line(name: "C", type: .bus, subtype: .regular)

    let bookmark  = Bookmark(name: "name", lines: [bus1, bus2, bus3])
    let viewModel = BookmarkCellViewModel(bookmark)

    let spacing = Layout.LinesLabel.horizontalSpacing
    let caption = bookmark.lines.map { $0.name }.joined(separator: spacing)

    XCTAssertEqual(viewModel.name,  NSAttributedString(string: bookmark.name, attributes: TextStyles.name))
    XCTAssertEqual(viewModel.lines, NSAttributedString(string: caption,       attributes: TextStyles.lines))
  }

  func test_bookmark_withMultipleLines_showsSortedLines() {
    let tram1 = Line(name: "2", type: .tram, subtype: .regular)
    let tram2 = Line(name: "1", type: .tram, subtype: .regular)

    let bus1 = Line(name: "B", type: .bus, subtype: .regular)
    let bus2 = Line(name: "C", type: .bus, subtype: .regular)
    let bus3 = Line(name: "A", type: .bus, subtype: .regular)

    // changer order, so we also test sorting
    let bookmark  = Bookmark(name: "name", lines: [tram1, tram2, bus1, bus2, bus3])
    let viewModel = BookmarkCellViewModel(bookmark)

    let spacing = Layout.LinesLabel.horizontalSpacing
    let tramCaption = [tram2, tram1]    .map { $0.name }.joined(separator: spacing)
    let busCaption  = [bus3, bus1, bus2].map { $0.name }.joined(separator: spacing)
    let caption = "\(tramCaption)\n\(busCaption)"

    XCTAssertEqual(viewModel.name,  NSAttributedString(string: bookmark.name, attributes: TextStyles.name))
    XCTAssertEqual(viewModel.lines, NSAttributedString(string: caption,       attributes: TextStyles.lines))
  }
}
