//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

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
