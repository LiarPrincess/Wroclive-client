// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import WrocliveTestsShared
@testable import WrocliveFramework

private typealias Constants = BookmarksCard.Constants.Cell
private let nameAttributes = Constants.Name.attributes
private let linesAttributes = Constants.Lines.attributes
private let horizontalSpacing = Constants.Lines.horizontalSpacing

class BookmarksCellViewModelTests: XCTestCase {

  func test_withoutLines_showsJustName() {
    let bookmark = Bookmark(name: "name", lines: [])
    let cell = BookmarksCellViewModel(bookmark: bookmark)

    XCTAssertEqual(
      cell.nameText,
      NSAttributedString(string: bookmark.name, attributes: nameAttributes)
    )

    XCTAssertEqual(
      cell.linesText,
      NSAttributedString(string: "", attributes: linesAttributes)
    )
  }

  func test_withOnlyTrams_showsSingleTramLine() {
    let tram1 = Line(name: "1", type: .tram, subtype: .regular)
    let tram2 = Line(name: "2", type: .tram, subtype: .regular)
    let tram3 = Line(name: "3", type: .tram, subtype: .regular)

    let bookmark = Bookmark(name: "name", lines: [tram1, tram2, tram3])
    let cell = BookmarksCellViewModel(bookmark: bookmark)

    XCTAssertEqual(
      cell.nameText,
      NSAttributedString(string: bookmark.name, attributes: nameAttributes)
    )

    let caption = bookmark.lines
      .map { $0.name }
      .joined(separator: horizontalSpacing)

    XCTAssertEqual(
      cell.linesText,
      NSAttributedString(string: caption, attributes: linesAttributes)
    )
  }

  func test_withOnlyBuses_showsSingleBusLine() {
    let bus1 = Line(name: "A", type: .bus, subtype: .regular)
    let bus2 = Line(name: "B", type: .bus, subtype: .regular)
    let bus3 = Line(name: "C", type: .bus, subtype: .regular)

    let bookmark = Bookmark(name: "name", lines: [bus1, bus2, bus3])
    let cell = BookmarksCellViewModel(bookmark: bookmark)

    XCTAssertEqual(
      cell.nameText,
      NSAttributedString(string: bookmark.name, attributes: nameAttributes)
    )

    let caption = bookmark.lines
      .map { $0.name }
      .joined(separator: horizontalSpacing)

    XCTAssertEqual(
      cell.linesText,
      NSAttributedString(string: caption, attributes: linesAttributes)
    )
  }

  func test_withMultipleLines_showsSortedLines() {
    let tram1 = Line(name: "2", type: .tram, subtype: .regular)
    let tram2 = Line(name: "1", type: .tram, subtype: .regular)

    let bus1 = Line(name: "B", type: .bus, subtype: .regular)
    let bus2 = Line(name: "C", type: .bus, subtype: .regular)
    let bus3 = Line(name: "A", type: .bus, subtype: .regular)

    // Change order, so we also test sorting
    let bookmark = Bookmark(name: "name", lines: [tram1, tram2, bus1, bus2, bus3])
    let cell = BookmarksCellViewModel(bookmark: bookmark)

    XCTAssertEqual(
      cell.nameText,
      NSAttributedString(string: bookmark.name, attributes: nameAttributes)
    )

    let tramCaption = [tram2, tram1]
      .map { $0.name }
      .joined(separator: horizontalSpacing)
    let busCaption = [bus3, bus1, bus2]
      .map { $0.name }
      .joined(separator: horizontalSpacing)
    let caption = "\(tramCaption)\n\(busCaption)"

    XCTAssertEqual(
      cell.linesText,
      NSAttributedString(string: caption, attributes: linesAttributes)
    )
  }
}
