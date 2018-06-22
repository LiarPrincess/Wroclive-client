// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest

class TutorialScreenshots: XCTestCase {

  func testScreenshots() {
    let app = XCUIApplication()
    app.launchArguments.append("Tutorial")
    setupSnapshot(app)
    app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.configuration"].tap()
    app.scrollViews.otherElements.tables.cells["ConfigurationCellView.tutorial"].tap()

    let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 2)
    snapshot("Tutorial_Page01")
    element.swipeLeft()
    snapshot("Tutorial_Page02")
    element.swipeLeft()
    snapshot("Tutorial_Page03")
  }
}
