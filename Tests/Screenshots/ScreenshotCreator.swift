//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest

class ScreenshotCreator: XCTestCase {

  var app: XCUIApplication!

  // MARK: Init/Deinit

  override func setUp() {
    super.setUp()

    self.app = XCUIApplication()
    app.launchEnvironment = ["Screenshots": "true"]
    setupSnapshot(app)
    self.app.launch()
  }

  override func tearDown() {
    super.tearDown()
  }

  // MARK: Tests

  func testScreenshots() {
    snapshot("01Map")
//    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.bookmarks"].tap()
//    snapshot("02BookmarksEmpty")
  }
}
