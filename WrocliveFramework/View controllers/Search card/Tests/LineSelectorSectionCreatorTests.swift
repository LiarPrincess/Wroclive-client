// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxTest
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

class LineSelectorSectionCreatorTests: XCTestCase, RxTestCase, EnvironmentTestCase {

  var scheduler:  TestScheduler!
  var disposeBag: DisposeBag!

  override func setUp() {
    super.setUp()
    self.setUpRx()
    self.setUpEnvironment()
  }

  override func tearDown() {
    super.tearDown()
    self.tearDownEnvironment()
    self.tearDownRx()
  }

  func test_withoutLines_returnsNoSections() {
    let lines = [Line]()
    let sections = LineSelectorSectionCreator.create(lines)
    XCTAssertEqual(sections, [])
  }

  func test_withLines_returnsSections() {
    let line0 = Line(name: "0", type: .tram, subtype: .express)
    let line1 = Line(name: "1", type: .tram, subtype: .express)
    let line2 = Line(name: "2", type: .tram, subtype: .regular)
    let line3 = Line(name: "3", type:  .bus, subtype: .regular)
    let line4 = Line(name: "4", type:  .bus, subtype: .night)
    let line5 = Line(name: "5", type:  .bus, subtype: .suburban)
    let line6 = Line(name: "6", type:  .bus, subtype: .peakHour)
    let line7 = Line(name: "7", type:  .bus, subtype: .zone)
    let line8 = Line(name: "8", type:  .bus, subtype: .limited)
    let line9 = Line(name: "9", type:  .bus, subtype: .temporary)

    // just for fun lets also reverse list
    let lines = [line0, line1, line2, line3, line4, line5, line6, line7, line8, line9].reversed()
    let sections = LineSelectorSectionCreator.create(Array(lines))

    let expectedSections = [
      self.createSection(subtype: .express,   lines: line0, line1),
      self.createSection(subtype: .regular,   lines: line2, line3),
      self.createSection(subtype: .night,     lines: line4),
      self.createSection(subtype: .suburban,  lines: line5),
      self.createSection(subtype: .peakHour,  lines: line6),
      self.createSection(subtype: .zone,      lines: line7),
      self.createSection(subtype: .limited,   lines: line8),
      self.createSection(subtype: .temporary, lines: line9)
    ]
    XCTAssertEqual(sections, expectedSections)
  }

  private func createSection(subtype lineSubtype: LineSubtype, lines: Line...) -> LineSelectorSection {
    let data = LineSelectorSectionData(for: lineSubtype)
    return LineSelectorSection(model: data, items: lines)
  }
}
