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
    self.app.launchArguments.append("Tutorial")
    setupSnapshot(app)
    self.app.launch()

    snapshot("Tutorial_Page01")
    let element = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0)
    element.swipeLeft()
    snapshot("Tutorial_Page02")
    element.swipeLeft()
    snapshot("Tutorial_Page03")
  }
}
