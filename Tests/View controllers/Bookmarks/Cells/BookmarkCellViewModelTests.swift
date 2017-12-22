//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

final class BookmarkCellViewModelTests: XCTestCase {

  // MARK: - Properties

  private var viewModel:     BookmarkCellViewModel!
  private var testScheduler: TestScheduler!
  private let disposeBag = DisposeBag()

  // MARK: - Init

  override func setUp() {
    super.setUp()
    self.viewModel     = BookmarkCellViewModel()
    self.testScheduler = TestScheduler(initialClock: 0)
  }

  override func tearDown() {
    super.tearDown()
    self.viewModel     = nil
    self.testScheduler = nil
  }

  // MARK: - Test - Name

  func test_nameChanges_onBookmarkChange() {
    let event0 = BookmarkEvent(time: 100, bookmark: Bookmark(name: "test0", lines: []))
    let event1 = BookmarkEvent(time: 200, bookmark: Bookmark(name: "test1", lines: []))
    self.simulateBookmarkEvents(event0, event1)

    let observer = self.testScheduler.createObserver(String.self)
    self.viewModel.outputs.name
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(100, "test0"), next(200, "test1")]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  // MARK: - Test - Lines

  func test_linesChange_onBookmarkChange() {
    let tram1 = Line(name: "1", type: .tram, subtype: .regular)
    let tram2 = Line(name: "2", type: .tram, subtype: .regular)

    let bus1 = Line(name: "A", type: .bus, subtype: .regular)
    let bus2 = Line(name: "B", type: .bus, subtype: .regular)

    let event0 = BookmarkEvent(time: 100, bookmark: Bookmark(name: "", lines: [tram1, bus1]))
    let event1 = BookmarkEvent(time: 200, bookmark: Bookmark(name: "", lines: [tram1, bus1, tram2, bus2]))
    self.simulateBookmarkEvents(event0, event1)

    let observer = self.testScheduler.createObserver(String.self)
    self.viewModel.outputs.lines
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(100, "1\nA"), next(200, "1   2\nA   B")]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  // MARK: - Helper - Events

  private struct BookmarkEvent {
    let time:     TestTime
    let bookmark: Bookmark

    var recordedEvent: Recorded<Event<Bookmark>> {
      return next(self.time, self.bookmark)
    }
  }

  private func simulateBookmarkEvents(_ events: BookmarkEvent...) {
    let recordedEvents = events.map { $0.recordedEvent }
    testScheduler.createHotObservable(recordedEvents)
      .bind(to: self.viewModel.inputs.bookmark)
      .disposed(by: self.disposeBag)
  }
}
