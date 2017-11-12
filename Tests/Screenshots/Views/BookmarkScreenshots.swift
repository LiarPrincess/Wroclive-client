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
    self.app.launchArguments.append("BookmarksEmpty")
    setupSnapshot(app)
    self.app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.bookmarks"].tap()
    snapshot("Bookmarks_Empty")
  }

  func testFilledScreenshots() {
    self.app = XCUIApplication()
    self.app.launchArguments.append("BookmarksFilled")
    setupSnapshot(app)
    self.app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.bookmarks"].tap()
    snapshot("Bookmarks_Filled")
  }
}
