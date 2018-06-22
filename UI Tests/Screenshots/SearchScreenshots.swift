// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

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
