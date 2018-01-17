//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import PromiseKit
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import Wroclive

// swiftlint:disable file_length
// swiftlint:disable implicitly_unwrapped_optional

// TODO: add test: bookmark button + search button
// TODO: add test: api alert close -> request retry
// TODO: add test: bookmark alert -> name -> save bookmark

private typealias TextStyles = LineSelectorCellConstants.TextStyles

final class SearchCardViewModelTests: XCTestCase {

  // MARK: - Properties

  var trackingManager: TrackingManagerMock!
  var searchManager:   SearchManagerMock!
  var apiManager:      ApiManagerMock!

  var viewModel:     SearchCardViewModel!
  var testScheduler: TestScheduler!
  var disposeBag:    DisposeBag!

  // MARK: - Init

  override func setUp() {
    super.setUp()
    self.testScheduler = TestScheduler(initialClock: 0)
    self.disposeBag    = DisposeBag()

    self.trackingManager = TrackingManagerMock()
    self.searchManager   = SearchManagerMock()
    self.apiManager      = ApiManagerMock()
    AppEnvironment.push(api: self.apiManager, search: self.searchManager, tracking: self.trackingManager)
  }

  override func tearDown() {
    super.tearDown()
    self.testScheduler = nil
    self.disposeBag    = nil
    AppEnvironment.pop()
  }

  // MARK: - Page

  func test_startsWithPage_fromManager() {
    // tram
    self.searchManager.state = SearchCardState(page: .tram, selectedLines: [])
    self.viewModel = SearchCardViewModel()

    let observer1 = self.testScheduler.createObserver(LineType.self)
    viewModel.outputs.page.drive(observer1).disposed(by: self.disposeBag)
    self.testScheduler.start()

    XCTAssertEqual(observer1.events, [next(0, LineType.tram)])
    assertSearchOperationCount(get: 1, save: 0)

    // bus
    self.searchManager.state = SearchCardState(page: .bus, selectedLines: [])
    self.viewModel = SearchCardViewModel()

    let observer2 = self.testScheduler.createObserver(LineType.self)
    viewModel.outputs.page.drive(observer2).disposed(by: self.disposeBag)
    self.testScheduler.start()

    XCTAssertEqual(observer2.events, [next(0, LineType.bus)])
    assertSearchOperationCount(get: 2, save: 0)
  }

  func test_selectingPage_updatesPage() {
    self.searchManager.state = SearchCardState(page: .tram, selectedLines: [])
    self.viewModel = SearchCardViewModel()

    let type0 = next( 50, LineType.bus)
    let type1 = next(150, LineType.tram)
    self.simulatePageSelectedEvents(type0, type1)

    let line0 = next(100, LineType.tram)
    let line1 = next(200, LineType.bus)
    self.simulatePageDidTransitionEvents(line0, line1)

    let observer = self.testScheduler.createObserver(LineType.self)
    self.viewModel.outputs.page.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(  0, LineType.tram),
      next( 50, LineType.bus),
      next(100, LineType.tram),
      next(150, LineType.tram),
      next(200, LineType.bus)
    ]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  // MARK: - Lines - Appearing

  func test_appearing_updatesLines() {
    self.searchManager.state       = SearchCardState(page: .tram, selectedLines: [])
    self.apiManager.availableLines = Promise(value: self.testLines)
    self.viewModel = SearchCardViewModel()

    self.simulateViewDidAppearEvents(at: 100)

    let lineObserver = self.testScheduler.createObserver([Line].self)
    self.viewModel.outputs.lines.drive(lineObserver).disposed(by: self.disposeBag)

    let showApiErrorAlertObserver = self.testScheduler.createObserver(SearchCardApiAlert.self)
    self.viewModel.outputs.showApiErrorAlert.drive(showApiErrorAlertObserver).disposed(by: self.disposeBag)

    let isLineSelectorVisibleObserver = self.testScheduler.createObserver(Bool.self)
    self.viewModel.outputs.isLineSelectorVisible.drive(isLineSelectorVisibleObserver).disposed(by: self.disposeBag)

    let isPlaceholderVisibleObserver = self.testScheduler.createObserver(Bool.self)
    self.viewModel.outputs.isPlaceholderVisible.drive(isPlaceholderVisibleObserver).disposed(by: self.disposeBag)

    self.testScheduler.start()
    self.waitForLineResponse(1)

    self.assertEqual(lineObserver.events,                [next(0, []), next(100, self.testLines)])
    XCTAssertEqual(showApiErrorAlertObserver.events,     [])
    XCTAssertEqual(isLineSelectorVisibleObserver.events, [next(0, false), next(100, true)])
    XCTAssertEqual(isPlaceholderVisibleObserver.events,  [next(0, true),  next(100, false)])
    self.assertApiOperationCount(availableLines: 1)
  }

  func test_appearing_withoutLines_showsAlert() {
    self.searchManager.state       = SearchCardState(page: .tram, selectedLines: [])
    self.apiManager.availableLines = Promise(value: [Line]())
    self.viewModel = SearchCardViewModel()

    self.simulateViewDidAppearEvents(at: 100)

    let lineObserver = self.testScheduler.createObserver([Line].self)
    self.viewModel.outputs.lines.drive(lineObserver).disposed(by: self.disposeBag)

    let showApiErrorAlertObserver = self.testScheduler.createObserver(SearchCardApiAlert.self)
    self.viewModel.outputs.showApiErrorAlert.drive(showApiErrorAlertObserver).disposed(by: self.disposeBag)

    let isLineSelectorVisibleObserver = self.testScheduler.createObserver(Bool.self)
    self.viewModel.outputs.isLineSelectorVisible.drive(isLineSelectorVisibleObserver).disposed(by: self.disposeBag)

    let isPlaceholderVisibleObserver = self.testScheduler.createObserver(Bool.self)
    self.viewModel.outputs.isPlaceholderVisible.drive(isPlaceholderVisibleObserver).disposed(by: self.disposeBag)

    self.testScheduler.start()
    self.waitForApiErrorAlert(1)

    self.assertEqual(lineObserver.events,                [next(0, [])])
    XCTAssertEqual(showApiErrorAlertObserver.events,     [next(100, SearchCardApiAlert.generalError)])
    XCTAssertEqual(isLineSelectorVisibleObserver.events, [next(0, false)])
    XCTAssertEqual(isPlaceholderVisibleObserver.events,  [next(0, true)])
    self.assertApiOperationCount(availableLines: 1)
  }

  func test_appearing_withoutInternet_showsAlert() {
    self.searchManager.state       = SearchCardState(page: .tram, selectedLines: [])
    self.apiManager.availableLines = Promise(error: ApiError.noInternet)
    self.viewModel = SearchCardViewModel()

    self.simulateViewDidAppearEvents(at: 100)

    let lineObserver = self.testScheduler.createObserver([Line].self)
    viewModel.outputs.lines.drive(lineObserver).disposed(by: self.disposeBag)

    let showApiErrorAlertObserver = self.testScheduler.createObserver(SearchCardApiAlert.self)
    viewModel.outputs.showApiErrorAlert.drive(showApiErrorAlertObserver).disposed(by: self.disposeBag)

    let isLineSelectorVisibleObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.outputs.isLineSelectorVisible.drive(isLineSelectorVisibleObserver).disposed(by: self.disposeBag)

    let isPlaceholderVisibleObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.outputs.isPlaceholderVisible.drive(isPlaceholderVisibleObserver).disposed(by: self.disposeBag)

    self.testScheduler.start()
    self.waitForApiErrorAlert(1)

    self.assertEqual(lineObserver.events,                [next(0, [])])
    XCTAssertEqual(showApiErrorAlertObserver.events,     [next(100, SearchCardApiAlert.noInternet)])
    XCTAssertEqual(isLineSelectorVisibleObserver.events, [next(0, false)])
    XCTAssertEqual(isPlaceholderVisibleObserver.events,  [next(0, true)])
    self.assertApiOperationCount(availableLines: 1)
  }

  func test_appearing_withApiError_showsAlert() {
    self.searchManager.state       = SearchCardState(page: .tram, selectedLines: [])
    self.apiManager.availableLines = Promise(error: ApiError.connectionError)
    self.viewModel = SearchCardViewModel()

    self.simulateViewDidAppearEvents(at: 100)

    let lineObserver = self.testScheduler.createObserver([Line].self)
    viewModel.outputs.lines.drive(lineObserver).disposed(by: self.disposeBag)

    let showApiErrorAlertObserver = self.testScheduler.createObserver(SearchCardApiAlert.self)
    viewModel.outputs.showApiErrorAlert.drive(showApiErrorAlertObserver).disposed(by: self.disposeBag)

    let isLineSelectorVisibleObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.outputs.isLineSelectorVisible.drive(isLineSelectorVisibleObserver).disposed(by: self.disposeBag)

    let isPlaceholderVisibleObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.outputs.isPlaceholderVisible.drive(isPlaceholderVisibleObserver).disposed(by: self.disposeBag)

    self.testScheduler.start()
    self.waitForApiErrorAlert(1)

    self.assertEqual(lineObserver.events,                [next(0, [])])
    XCTAssertEqual(showApiErrorAlertObserver.events,     [next(100, SearchCardApiAlert.generalError)])
    XCTAssertEqual(isLineSelectorVisibleObserver.events, [next(0, false)])
    XCTAssertEqual(isPlaceholderVisibleObserver.events,  [next(0, true)])
    self.assertApiOperationCount(availableLines: 1)
  }

  // MARK: - Selected lines

  func test_startsWithSelectedLines_fromManager() {
    self.searchManager.state = SearchCardState(page: .tram, selectedLines: self.testLines)
    self.viewModel = SearchCardViewModel()

    let observer = self.testScheduler.createObserver([Line].self)
    viewModel.outputs.selectedLines.drive(observer).disposed(by: self.disposeBag)

    self.testScheduler.start()

    self.assertEqual(observer.events, [next(0, self.testLines)])
    assertSearchOperationCount(get: 1, save: 0)
  }

  func test_selectingLine_updatesSelectedLines() {
    self.searchManager.state = SearchCardState(page: .tram, selectedLines: self.testLines)
    self.viewModel = SearchCardViewModel()

    let event0 = next(100, Line(name: "Test0", type: .tram, subtype: .regular))
    let event1 = next(200, Line(name: "Test1", type: .bus,  subtype: .express))
    self.simulateLineSelectedEvents(event0, event1)

    let observer = self.testScheduler.createObserver([Line].self)
    viewModel.outputs.selectedLines.drive(observer).disposed(by: self.disposeBag)

    self.testScheduler.start()

    let expectedEvents = [
      next(  0, self.testLines),
      next(100, self.testLines + [event0.value.element!]),
      next(200, self.testLines + [event1.value.element!, event1.value.element!])]
    self.assertEqual(observer.events, expectedEvents)
    assertSearchOperationCount(get: 1, save: 0)
  }

  func test_deselectingLine_updatesSelectedLines() {
    self.searchManager.state = SearchCardState(page: .tram, selectedLines: self.testLines)
    self.viewModel = SearchCardViewModel()

    let event0 = next(100, self.testLines[0])
    let event1 = next(200, self.testLines[2])
    self.simulateLineDeselectedEvents(event0, event1)

    let observer = self.testScheduler.createObserver([Line].self)
    viewModel.outputs.selectedLines.drive(observer).disposed(by: self.disposeBag)

    self.testScheduler.start()

    let expectedEvents = [
      next(  0, self.testLines),
      next(100, [self.testLines[1], self.testLines[2], self.testLines[3], self.testLines[4]]),
      next(200, [self.testLines[1], self.testLines[2], self.testLines[4]])]
    self.assertEqual(observer.events, expectedEvents)
    assertSearchOperationCount(get: 1, save: 0)
  }

  // MARK: - Buttons

  func test_bookmarkButton_withLines_showsNameAlert() {
  }

  func test_bookmarkButton_withoutLines_showsAlert() {
  }

  func test_searchButton_startsTracking() {
  }

  func test_searchButton_closes() {
    self.viewModel = SearchCardViewModel()

    self.simulateSearchButtonPressedEvents(at: 100, 200)

    let observer = self.testScheduler.createObserver(Void.self)
    viewModel.outputs.shouldClose
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(100, ()), next(200, ())]
    self.assertEqual(observer.events, expectedEvents)
  }

  // MARK: - Alerts

  func test_closingApiAlert_delays_andUpdatesLines() {

  }

  func test_closingBookmarkAlert_withName_savesBookmark() {
  }

  // MARK: - Close

  func test_close_savesState() {
    self.searchManager.state = SearchCardState(page: .tram, selectedLines: [])
    self.viewModel = SearchCardViewModel()

    let page = LineType.bus
    let line = Line(name: "Test0", type: .bus,  subtype: .express)

    self.simulatePageSelectedEvents(next(100, page))
    self.simulateLineSelectedEvents(next(200, line))

    self.simulateViewDidDisappearEvents(at: 300)
    self.testScheduler.start()

    let expected = SearchCardState(page: page, selectedLines: [line])
    XCTAssertEqual(expected, self.searchManager.state)
    self.assertSearchOperationCount(get: 1, save: 1)
  }
}

// MARK: - Helpers

extension SearchCardViewModelTests {

  // MARK: - Data

  var testLines: [Line] {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    let line3 = Line(name:  "A", type:  .bus, subtype: .regular)
    let line4 = Line(name:  "D", type:  .bus, subtype: .regular)
    return [line0, line1, line2, line3, line4]
  }

  // MARK: - Page

  typealias PageSelectedEvent      = Recorded<Event<LineType>>
  typealias PageDidTransitionEvent = Recorded<Event<LineType>>

  func simulatePageSelectedEvents(_ events: PageSelectedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.pageSelected)
      .disposed(by: self.disposeBag)
  }

  func simulatePageDidTransitionEvents(_ events: PageDidTransitionEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.pageDidTransition)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Selected lines

  typealias LineSelectedEvent   = Recorded<Event<Line>>
  typealias LineDeselectedEvent = Recorded<Event<Line>>

  func simulateLineSelectedEvents(_ events: LineSelectedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.lineSelected)
      .disposed(by: self.disposeBag)
  }

  func simulateLineDeselectedEvents(_ events: LineDeselectedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.lineDeselected)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Buttons

  func simulateBookmarkButtonPressedEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.bookmarkButtonPressed)
      .disposed(by: self.disposeBag)
  }

  func simulateSearchButtonPressedEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.searchButtonPressed)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Alerts

  func simulateApiAlertTryAgainButtonPressedEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.apiAlertTryAgainButtonPressed)
      .disposed(by: self.disposeBag)
  }

  // MARK: - View controller lifecycle

  func simulateViewDidAppearEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.viewDidAppear)
      .disposed(by: self.disposeBag)
  }

  func simulateViewDidDisappearEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.viewDidDisappear)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Blocking

  /// Waif 'till PromiseKit dispatch_async response
  private func waitForLineResponse(_ count: Int) {
    let startsWith = 1
    let observable = self.viewModel.outputs.showApiErrorAlert.asObservable()
    self.wait(for: observable, count: startsWith + count)
  }

  /// Waif 'till PromiseKit dispatch_async response
  private func waitForApiErrorAlert(_ count: Int) {
    let observable = self.viewModel.outputs.showApiErrorAlert.asObservable()
    self.wait(for: observable, count: count)
  }

  private func wait<Element>(for observable: Observable<Element>, count: Int) {
    _ = try? observable
      .take(count)
      .toBlocking(timeout: 2)
      .toArray()
  }

  // MARK: - Asserts

  typealias VoidEvent  = Recorded<Event<Void>>
  typealias LinesEvent = Recorded<Event<[Line]>>

  func assertSearchOperationCount(get: Int, save: Int) {
    XCTAssertEqual(self.searchManager.getStateCount, get)
    XCTAssertEqual(self.searchManager.saveCount, save)
  }

  func assertApiOperationCount(availableLines: Int) {
    XCTAssertEqual(self.apiManager.availableLinesCallCount, availableLines)
  }

  func assertEqual(_ lhs: [VoidEvent], _ rhs: [VoidEvent]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
      XCTAssertEqual(lhsEvent.time, rhsEvent.time)
    }
  }

  func assertEqual(_ lhs: [LinesEvent], _ rhs: [LinesEvent]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
      XCTAssertEqual(lhsEvent.time, rhsEvent.time)
    }
  }
}
