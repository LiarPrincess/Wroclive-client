//
//  Radar_Tests.swift
//  Radar-Tests
//
//  Created by Michal Matuszczyk on 09/11/2017.
//

import XCTest
import Quick
import Nimble

class Radar_Tests: XCTestCase {

  // MARK: Init/Deinit

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  // MARK: Tests

  func testExample() {
    expect(1 + 1).to(equal(2))
    expect(1.2).to(beCloseTo(1.1, within: 0.1))
    expect(3) > 2
    expect("seahorse").to(contain("sea"))
    expect(["Atlantic", "Pacific"]).toNot(contain("Mississippi"))
  }
}
