//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest

class SearchScreenshots: XCTestCase {

  // MARK: Trams

  func testTramLoading() {
    let app = XCUIApplication()
    app.launchArguments.append("Search_Tram_Loading")
    setupSnapshot(app)
    app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.search"].tap()
    snapshot("Search_Tram_Loading")
  }

  func testTramNoSelectedScreenshots() {
    let app = XCUIApplication()
    app.launchArguments.append("Search_Tram_NoSelected")
    setupSnapshot(app)
    app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.search"].tap()
    snapshot("Search_Tram_NoSelected")
  }

  func testTramSelectedScreenshots() {
    let app = XCUIApplication()
    app.launchArguments.append("Search_Tram_Selected")
    setupSnapshot(app)
    app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.search"].tap()
    snapshot("Search_Tram_Selected")
  }

  // MARK: Busses

  func testBusLoading() {
    let app = XCUIApplication()
    app.launchArguments.append("Search_Bus_Loading")
    setupSnapshot(app)
    app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.search"].tap()
    snapshot("Search_Bus_Loading")
  }

  func testBusNoSelectedScreenshots() {
    let app = XCUIApplication()
    app.launchArguments.append("Search_Bus_NoSelected")
    setupSnapshot(app)
    app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.search"].tap()
    snapshot("Search_Bus_NoSelected")
  }

  func testBusSelectedScreenshots() {
    let app = XCUIApplication()
    app.launchArguments.append("Search_Bus_Selected")
    setupSnapshot(app)
    app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.search"].tap()
    snapshot("Search_Bus_Selected")
  }
}
