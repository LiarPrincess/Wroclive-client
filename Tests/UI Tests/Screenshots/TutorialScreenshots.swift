//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

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
