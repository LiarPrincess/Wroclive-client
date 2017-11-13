//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest

class BookmarkScreenshots: XCTestCase {

  // MARK: Properties

  fileprivate(set) var app: XCUIApplication!

  // MARK: Tests

  func testEmptyScreenshots() {
    self.app = XCUIApplication()
    self.app.launchArguments.append("Bookmarks_Empty")
    setupSnapshot(app)
    self.app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.bookmarks"].tap()
    snapshot("Bookmarks_Empty")
  }

  func testFilledScreenshots() {
    self.app = XCUIApplication()
    self.app.launchArguments.append("Bookmarks_Filled")
    setupSnapshot(app)
    self.app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.bookmarks"].tap()
    snapshot("Bookmarks_Filled")
  }

  func testFilledEditScreenshots() {
    self.app = XCUIApplication()
    self.app.launchArguments.append("Bookmarks_Filled")
    setupSnapshot(app)
    self.app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.bookmarks"].tap()
    app.buttons["BookmarksViewController.edit"].tap()
    snapshot("Bookmarks_Filled_Edit")
  }
}
