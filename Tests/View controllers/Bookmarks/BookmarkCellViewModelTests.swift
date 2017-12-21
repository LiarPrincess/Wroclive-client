//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import Wroclive

final class BookmarkCellViewModelTests: XCTestCase {

  // MARK: - Properties

  private var viewModel:     BookmarkCellViewModel!
  private var testScheduler: TestScheduler!
  private let disposeBag = DisposeBag()

  // MARK: setUp/tearDown

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

  // MARK: Tests

  func test_emitName_onBookmarkInput() {
    let source = PublishSubject<Bookmark>()
    source
      .bind(to: self.viewModel.inputs.bookmark)
      .disposed(by: self.disposeBag)

    var result: String!
    self.viewModel.outputs.name
      .drive(onNext: { result = $0 })
      .disposed(by: self.disposeBag)

    source.onNext(Bookmark(name: "test", lines: []))
    XCTAssertEqual(result, "test")
  }

  func test_changeName_onBookmarkChange() {
    let event0 = BookmarkEvent(time: 100, bookmark: Bookmark(name: "test0", lines: []))
    let event1 = BookmarkEvent(time: 200, bookmark: Bookmark(name: "test1", lines: []))
    self.simulateBookmarkEvents(event0, event1)

    let observer = self.testScheduler.createObserver(String.self)
    self.viewModel.outputs.name
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let events         = observer.events
    let expectedEvents = [next(100, "test0"), next(200, "test1")]
    XCTAssertEqual(events, expectedEvents)
  }

  func test_emitSortedLines_onBookmarkInput() {
    let source = PublishSubject<Bookmark>()
    source
      .bind(to: self.viewModel.inputs.bookmark)
      .disposed(by: self.disposeBag)

    var result: String!
    self.viewModel.outputs.lines
      .drive(onNext: { result = $0 })
      .disposed(by: self.disposeBag)

    let tram1 = Line(name: "1", type: .tram, subtype: .regular)
    let tram2 = Line(name: "2", type: .tram, subtype: .regular)
    let tram3 = Line(name: "3", type: .tram, subtype: .regular)

    let bus1 = Line(name: "A", type: .bus, subtype: .regular)
    let bus2 = Line(name: "B", type: .bus, subtype: .regular)

    source.onNext(Bookmark(name: "", lines: [bus1, bus2, tram1, tram3, tram2]))
    XCTAssertEqual(result, "1   2   3\nA   B")
  }

  func test_changeLines_onBookmarkChange() {
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

    let events         = observer.events
    let expectedEvents = [next(100, "1\nA"), next(200, "1   2\nA   B")]
    XCTAssertEqual(events, expectedEvents)
  }

  // MARK: - BookmarkEvent

  private struct BookmarkEvent {
    let time:     TestTime
    let bookmark: Bookmark

    var recordedEvent: Recorded<Event<Bookmark>> {
      return next(self.time, self.bookmark)
    }
  }

  private func simulateBookmarkEvents(_ events: BookmarkEvent...) {
    let recordedEvents = events.map { $0.recordedEvent }
    let observable = testScheduler.createHotObservable(recordedEvents)
    observable
      .bind(to: self.viewModel.inputs.bookmark)
      .disposed(by: self.disposeBag)
  }
}
