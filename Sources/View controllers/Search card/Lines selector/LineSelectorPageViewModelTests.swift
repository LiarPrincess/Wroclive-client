//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

// swiftlint:disable implicitly_unwrapped_optional

final class LineSelectorPageViewModelTests: XCTestCase {

  // MARK: - Properties

  var viewModel:     LineSelectorPageViewModel!
  var testScheduler: TestScheduler!
  let disposeBag = DisposeBag()

  // MARK: - Init

  override func setUp() {
    super.setUp()
    self.viewModel     = LineSelectorPageViewModel()
    self.testScheduler = TestScheduler(initialClock: 0)
  }

  override func tearDown() {
    super.tearDown()
    self.viewModel     = nil
    self.testScheduler = nil
  }

  // MARK: - Lines changed

  func test_updatesSections_onLinesChange() {
    let line0 = Line(name: "3", type: .tram, subtype: .regular)
    let line1 = Line(name: "2", type: .tram, subtype: .regular)
    let line2 = Line(name: "1", type: .tram, subtype: .express)
    let line3 = Line(name: "A", type:  .bus, subtype: .express)
    let line4 = Line(name: "D", type:  .bus, subtype: .night)

    let event0 = next(100, [line0, line3])
    let event1 = next(200, [line0, line1, line2, line3, line4])
    let event2 = next(300, [Line]())
    self.simulateLinesChangedEvents(event0, event1, event2)

    let observer = self.testScheduler.createObserver([LineSelectorSection].self)
    self.viewModel.outputs.sections
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(100, [
        self.createSection(subtype: .express, lines: [line3]),
        self.createSection(subtype: .regular, lines: [line0])
      ]),
      next(200, [
        self.createSection(subtype: .express, lines: [line3, line2]),
        self.createSection(subtype: .regular, lines: [line1, line0]),
        self.createSection(subtype: .night,   lines: [line4])
      ]),
      next(300, [LineSelectorSection]())
    ]
    self.assertEqual(observer.events, expectedEvents)
  }

  // MARK: - Selected lines changed

  func test_updatesSelectedLines_onSelectedLinesChange() {
    let line0 = Line(name: "3", type: .tram, subtype: .regular)
    let line1 = Line(name: "2", type: .tram, subtype: .regular)
    let line2 = Line(name: "1", type: .tram, subtype: .express)
    let line3 = Line(name: "A", type:  .bus, subtype: .express)
    let line4 = Line(name: "D", type:  .bus, subtype: .night)

    let event0 = next(100, [line0, line3])
    let event1 = next(200, [line0, line1, line2, line3, line4])
    let event2 = next(300, [Line]())
    self.simulateSelectedLinesChangedEvents(event0, event1, event2)

    let observer = self.testScheduler.createObserver([Line].self)
    self.viewModel.outputs.selectedLines
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [event0, event1, event2]
    self.assertEqual(observer.events, expectedEvents)
  }
}

// MARK: - Helpers

extension LineSelectorPageViewModelTests {

  // MARK: - Lines changed

  typealias LinesChangedEvent = Recorded<Event<[Line]>>
  typealias SectionEvent      = Recorded<Event<[LineSelectorSection]>>

  func simulateLinesChangedEvents(_ events: LinesChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.linesChanged)
      .disposed(by: self.disposeBag)
  }

  func createSection(subtype lineSubtype: LineSubtype, lines: [Line]) -> LineSelectorSection {
    let data = LineSelectorSectionData(for: lineSubtype)
    return LineSelectorSection(model: data, items: lines.sorted(by: .name))
  }

  func assertEqual(_ lhs: [SectionEvent], _ rhs: [SectionEvent]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
      XCTAssertEqual(lhsEvent.time, rhsEvent.time)

      let lhsElement = lhsEvent.value.element!
      let rhsElement = rhsEvent.value.element!
      XCTAssertEqual(lhsElement, rhsElement)
    }
  }

  // MARK: - Selected lines changed

  typealias SelectedLinesChangedEvent = Recorded<Event<[Line]>>

  func simulateSelectedLinesChangedEvents(_ events: SelectedLinesChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.selectedLinesChanged)
      .disposed(by: self.disposeBag)
  }

  func assertEqual(_ lhs: [SelectedLinesChangedEvent], _ rhs: [SelectedLinesChangedEvent]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
      XCTAssertEqual(lhsEvent.time, rhsEvent.time)

      let lhsElement = lhsEvent.value.element!
      let rhsElement = rhsEvent.value.element!
      XCTAssertEqual(lhsElement, rhsElement)
    }
  }
}
