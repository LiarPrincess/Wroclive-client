//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest

class TutorialScreenshots: XCTestCase {

  // MARK: Properties

  fileprivate(set) var app: XCUIApplication!

  // MARK: Tests

  func testScreenshots() {
    self.app = XCUIApplication()
    self.app.launchArguments.append("ShowTutorial")
    setupSnapshot(app)
    self.app.launch()

    snapshot("01Tutorial")
    let element = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0)
    element.swipeLeft()
    snapshot("02Tutorial")
    element.swipeLeft()
    snapshot("03Tutorial")

    //    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.bookmarks"].tap()
    //    snapshot("02BookmarksEmpty")
  }
}
