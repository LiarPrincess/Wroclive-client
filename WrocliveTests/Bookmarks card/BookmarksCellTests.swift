// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

private typealias Constants = BookmarksCard.Constants.Cell
private let nameAttributes = Constants.Name.attributes
private let linesAttributes = Constants.Lines.attributes
private let horizontalSpacing = Constants.Lines.horizontalSpacing

class BookmarksCellTests: XCTestCase, EnvironmentTestCase {

  var environment: Environment!

  override func setUp() {
    super.setUp()
    self.setUpEnvironment()
  }

  func test_bookmark_withoutLines_showsJustName() {
    let bookmark = Bookmark(name: "name", lines: [])
    let cell = self.render(bookmark: bookmark)

    XCTAssertEqual(
      cell.name,
      NSAttributedString(string: bookmark.name, attributes: nameAttributes)
    )

    XCTAssertEqual(
      cell.lines,
      NSAttributedString(string: "", attributes: linesAttributes)
    )
  }

  func test_bookmark_withOnlyTrams_showsSingleTramLine() {
    let tram1 = Line(name: "1", type: .tram, subtype: .regular)
    let tram2 = Line(name: "2", type: .tram, subtype: .regular)
    let tram3 = Line(name: "3", type: .tram, subtype: .regular)

    let bookmark = Bookmark(name: "name", lines: [tram1, tram2, tram3])
    let cell = self.render(bookmark: bookmark)

    XCTAssertEqual(
      cell.name,
      NSAttributedString(string: bookmark.name, attributes: nameAttributes)
    )

    let caption = bookmark.lines
      .map { $0.name }
      .joined(separator: horizontalSpacing)

    XCTAssertEqual(
      cell.lines,
      NSAttributedString(string: caption, attributes: linesAttributes)
    )
  }

  func test_bookmark_withOnlyBuses_showsSingleBusLine() {
    let bus1 = Line(name: "A", type: .bus, subtype: .regular)
    let bus2 = Line(name: "B", type: .bus, subtype: .regular)
    let bus3 = Line(name: "C", type: .bus, subtype: .regular)

    let bookmark = Bookmark(name: "name", lines: [bus1, bus2, bus3])
    let cell = self.render(bookmark: bookmark)

    XCTAssertEqual(
      cell.name,
      NSAttributedString(string: bookmark.name, attributes: nameAttributes)
    )

    let caption = bookmark.lines
      .map { $0.name }
      .joined(separator: horizontalSpacing)

    XCTAssertEqual(
      cell.lines,
      NSAttributedString(string: caption, attributes: linesAttributes)
    )
  }

  func test_bookmark_withMultipleLines_showsSortedLines() {
    let tram1 = Line(name: "2", type: .tram, subtype: .regular)
    let tram2 = Line(name: "1", type: .tram, subtype: .regular)

    let bus1 = Line(name: "B", type: .bus, subtype: .regular)
    let bus2 = Line(name: "C", type: .bus, subtype: .regular)
    let bus3 = Line(name: "A", type: .bus, subtype: .regular)

    // Change order, so we also test sorting
    let bookmark = Bookmark(name: "name", lines: [tram1, tram2, bus1, bus2, bus3])
    let cell = self.render(bookmark: bookmark)

    XCTAssertEqual(
      cell.name,
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
      cell.lines,
      NSAttributedString(string: caption, attributes: linesAttributes)
    )
  }

  // MARK: - Render

  private struct Cell {
    let name: NSAttributedString
    let lines: NSAttributedString
  }

  private func render(bookmark: Bookmark) -> Cell {
    let name = BookmarksCell.createNameText(bookmark: bookmark)
    let lines = BookmarksCell.createLinesText(bookmark: bookmark)
    return Cell(name: name, lines: lines)
  }
}
