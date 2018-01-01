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

final class LineSelectionViewModelTests: XCTestCase {

  // MARK: - Properties

  var viewModel:     LineSelectionViewModel!
  var testScheduler: TestScheduler!
  let disposeBag = DisposeBag()

  // MARK: - Init

  override func setUp() {
    super.setUp()
    self.viewModel     = LineSelectionViewModel()
    self.testScheduler = TestScheduler(initialClock: 0)
  }

  override func tearDown() {
    super.tearDown()
    self.viewModel     = nil
    self.testScheduler = nil
  }

  // MARK: - Page changed

  func test_emitsPage_onPageChange() {
    let event0 = next(100, LineType.bus)
    let event1 = next(200, LineType.tram)
    self.simulatePageChangedEvents(event0, event1)

    let observer = self.testScheduler.createObserver(LineType.self)
    self.viewModel.outputs.page
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(100, LineType.bus),
      next(200, LineType.tram)
    ]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  // MARK: - Lines changed

  func test_tramLinesChange_onLinesChange() {
    let line0 = Line(name: "3", type: .tram, subtype: .regular)
    let line1 = Line(name: "2", type: .tram, subtype: .regular)
    let line2 = Line(name: "1", type: .tram, subtype: .express)
    let line3 = Line(name: "A", type:  .bus, subtype: .express)
    let line4 = Line(name: "D", type:  .bus, subtype: .night)

    let event0 = next(100, [line0, line3, line4])
    let event1 = next(200, [line0, line1, line2, line3, line4])
    let event2 = next(300, [Line]())
    self.simulateLinesChangedEvents(event0, event1, event2)

    let observer = self.testScheduler.createObserver([Line].self)
    self.viewModel.outputs.tramLines
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(100, [line0]),
      next(200, [line0, line1, line2]),
      next(300, [Line]())
    ]
    self.assertEqual(observer.events, expectedEvents)
  }

  func test_busLinesChange_onLinesChange() {
    let line0 = Line(name: "3", type: .tram, subtype: .regular)
    let line1 = Line(name: "2", type: .tram, subtype: .regular)
    let line2 = Line(name: "1", type: .tram, subtype: .express)
    let line3 = Line(name: "A", type:  .bus, subtype: .express)
    let line4 = Line(name: "D", type:  .bus, subtype: .night)

    let event0 = next(100, [line0, line3])
    let event1 = next(200, [line0, line1, line2, line3, line4])
    let event2 = next(300, [Line]())
    self.simulateLinesChangedEvents(event0, event1, event2)

    let observer = self.testScheduler.createObserver([Line].self)
    self.viewModel.outputs.busLines
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(100, [line3]),
      next(200, [line3, line4]),
      next(300, [Line]())
    ]
    self.assertEqual(observer.events, expectedEvents)
  }

  // MARK: - Selected lines changed

  func test_selectedTramLinesChange_onSelectedLinesChange() {
    let line0 = Line(name: "3", type: .tram, subtype: .regular)
    let line1 = Line(name: "2", type: .tram, subtype: .regular)
    let line2 = Line(name: "1", type: .tram, subtype: .express)
    let line3 = Line(name: "A", type:  .bus, subtype: .express)
    let line4 = Line(name: "D", type:  .bus, subtype: .night)

    let event0 = next(100, [line0, line3, line4])
    let event1 = next(200, [line0, line1, line2, line3, line4])
    let event2 = next(300, [Line]())
    self.simulateSelectedLinesChangedEvents(event0, event1, event2)

    let observer = self.testScheduler.createObserver([Line].self)
    self.viewModel.outputs.selectedTramLines
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(100, [line0]),
      next(200, [line0, line1, line2]),
      next(300, [Line]())
    ]
    self.assertEqual(observer.events, expectedEvents)
  }

  func test_selectedBusLinesChange_onSelectedLinesChange() {
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
    self.viewModel.outputs.selectedBusLines
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(100, [line3]),
      next(200, [line3, line4]),
      next(300, [Line]())
    ]
    self.assertEqual(observer.events, expectedEvents)
  }
}
