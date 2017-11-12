//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest

class SearchScreenshots: XCTestCase {

  // MARK: Properties

  fileprivate(set) var app: XCUIApplication!

  // MARK: Test - Trams

  func testTramLoading() {
    self.app = XCUIApplication()
    self.app.launchArguments.append("Search_Tram_Loading")
    setupSnapshot(app)
    self.app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.search"].tap()
    snapshot("Search_Tram_Loading")
  }

  func testTramNoSelectedScreenshots() {
    self.app = XCUIApplication()
    self.app.launchArguments.append("Search_Tram_NoSelected")
    setupSnapshot(app)
    self.app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.search"].tap()
    snapshot("Search_Tram_NoSelected")
  }

  func testTramSelectedScreenshots() {
    self.app = XCUIApplication()
    self.app.launchArguments.append("Search_Tram_Selected")
    setupSnapshot(app)
    self.app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.search"].tap()
    snapshot("Search_Tram_Selected")
  }

  // MARK: Test - Bus

  func testBusLoading() {
    self.app = XCUIApplication()
    self.app.launchArguments.append("Search_Bus_Loading")
    setupSnapshot(app)
    self.app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.search"].tap()
    snapshot("Search_Bus_Loading")
  }

  func testBusNoSelectedScreenshots() {
    self.app = XCUIApplication()
    self.app.launchArguments.append("Search_Bus_NoSelected")
    setupSnapshot(app)
    self.app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.search"].tap()
    snapshot("Search_Bus_NoSelected")
  }

  func testBusSelectedScreenshots() {
    self.app = XCUIApplication()
    self.app.launchArguments.append("Search_Bus_Selected")
    setupSnapshot(app)
    self.app.launch()

    app.toolbars["MainViewController.toolbar"].buttons["MainViewController.search"].tap()
    snapshot("Search_Bus_Selected")
  }
}
