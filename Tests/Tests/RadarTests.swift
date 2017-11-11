//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Radar

class RadarTests: XCTestCase {

  // MARK: Init/Deinit

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  // MARK: Tests

  func testExample() {
    let hasCompletedTutorial = Managers.tutorial.hasCompleted

    expect(1 + 1).to(equal(2))
    expect(1.2).to(beCloseTo(1.1, within: 0.1))
    expect(3) > 2
    expect("seahorse").to(contain("sea"))
    expect(["Atlantic", "Pacific"]).toNot(contain("Mississippi"))
  }
}
