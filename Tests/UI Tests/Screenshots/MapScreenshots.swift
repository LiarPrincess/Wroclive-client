//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest

class MapScreenshots: XCTestCase {

  // MARK: Properties

  fileprivate(set) var app: XCUIApplication!

  // MARK: Tests

  func testScreenshots() {
    self.app = XCUIApplication()
    setupSnapshot(app)
    self.app.launch()

    snapshot("Map")
  }
}
