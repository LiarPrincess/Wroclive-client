// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest

class BookmarkScreenshots: XCTestCase {

  func testEmptyScreenshots() {
    let app = XCUIApplication()
    app.launchArguments.append("Bookmarks_Empty")
    setupSnapshot(app)
    app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.bookmarks"].tap()
    snapshot("Bookmarks_Empty")
  }

  func testFilledScreenshots() {
    let app = XCUIApplication()
    app.launchArguments.append("Bookmarks_Filled")
    setupSnapshot(app)
    app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.bookmarks"].tap()
    snapshot("Bookmarks_Filled")
  }

  func testFilledEditScreenshots() {
    let app = XCUIApplication()
    app.launchArguments.append("Bookmarks_Filled")
    setupSnapshot(app)
    app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.bookmarks"].tap()
    app.buttons["BookmarksViewController.edit"].tap()
    snapshot("Bookmarks_Filled_Edit")
  }
}
