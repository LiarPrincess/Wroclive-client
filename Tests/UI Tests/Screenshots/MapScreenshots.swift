//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest

class MapScreenshots: XCTestCase {

  func testEmpty() {
    let app = XCUIApplication()
    setupSnapshot(app)
    app.launch()

    snapshot("Map")
  }
}
