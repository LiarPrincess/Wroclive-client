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

private typealias TextStyles = LineSelectorCellConstants.TextStyles

final class SearchCardViewModelTests: XCTestCase {

  // MARK: - Properties

  var bookmarksManager: BookmarksManagerMock!
  var trackingManager:  TrackingManagerMock!
  var searchManager:    SearchManagerMock!
  var apiManager:       ApiManagerMock!

  var viewModel:     SearchCardViewModel!
  var testScheduler: TestScheduler!
  var disposeBag:    DisposeBag!

  // MARK: - Init

  override func setUp() {
    super.setUp()
    self.testScheduler = TestScheduler(initialClock: 0)
    self.disposeBag    = DisposeBag()

    self.bookmarksManager = BookmarksManagerMock()
    self.trackingManager  = TrackingManagerMock()
    self.searchManager    = SearchManagerMock()
    self.apiManager       = ApiManagerMock()
    AppEnvironment.push(api: self.apiManager, search: self.searchManager, bookmarks: self.bookmarksManager, tracking: self.trackingManager)
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

    let observers = self.bindLineObserters()
    self.testScheduler.start()
    self.waitForLineResponse(1)

    self.assertEqual(observers.line.events,                [next(0, []), next(100, self.testLines)])
    XCTAssertEqual(observers.showApiErrorAlert.events,     [])
    XCTAssertEqual(observers.isLineSelectorVisible.events, [next(0, false), next(100, true)])
    XCTAssertEqual(observers.isPlaceholderVisible.events,  [next(0, true),  next(100, false)])
    self.assertApiOperationCount(availableLines: 1)
  }

  func test_appearing_withoutLines_showsAlert() {
    self.searchManager.state       = SearchCardState(page: .tram, selectedLines: [])
    self.apiManager.availableLines = Promise(value: [Line]())
    self.viewModel = SearchCardViewModel()

    self.simulateViewDidAppearEvents(at: 100)

    let observers = self.bindLineObserters()
    self.testScheduler.start()
    self.waitForApiErrorAlert(1)

    self.assertEqual(observers.line.events,                [next(0, [])])
    XCTAssertEqual(observers.showApiErrorAlert.events,     [next(100, SearchCardApiError.generalError)])
    XCTAssertEqual(observers.isLineSelectorVisible.events, [next(0, false)])
    XCTAssertEqual(observers.isPlaceholderVisible.events,  [next(0, true)])
    self.assertApiOperationCount(availableLines: 1)
  }

  func test_appearing_withoutInternet_showsAlert() {
    self.searchManager.state       = SearchCardState(page: .tram, selectedLines: [])
    self.apiManager.availableLines = Promise(error: ApiError.noInternet)
    self.viewModel = SearchCardViewModel()

    self.simulateViewDidAppearEvents(at: 100)

    let observers = self.bindLineObserters()
    self.testScheduler.start()
    self.waitForApiErrorAlert(1)

    self.assertEqual(observers.line.events,                [next(0, [])])
    XCTAssertEqual(observers.showApiErrorAlert.events,     [next(100, SearchCardApiError.noInternet)])
    XCTAssertEqual(observers.isLineSelectorVisible.events, [next(0, false)])
    XCTAssertEqual(observers.isPlaceholderVisible.events,  [next(0, true)])
    self.assertApiOperationCount(availableLines: 1)
  }

  func test_appearing_withApiError_showsAlert() {
    self.searchManager.state       = SearchCardState(page: .tram, selectedLines: [])
    self.apiManager.availableLines = Promise(error: ApiError.connectionError)
    self.viewModel = SearchCardViewModel()

    self.simulateViewDidAppearEvents(at: 100)

    let observers = self.bindLineObserters()
    self.testScheduler.start()
    self.waitForApiErrorAlert(1)

    self.assertEqual(observers.line.events,                [next(0, [])])
    XCTAssertEqual(observers.showApiErrorAlert.events,     [next(100, SearchCardApiError.generalError)])
    XCTAssertEqual(observers.isLineSelectorVisible.events, [next(0, false)])
    XCTAssertEqual(observers.isPlaceholderVisible.events,  [next(0, true)])
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
    self.searchManager.state = SearchCardState(page: .tram, selectedLines: self.testLines)
    self.viewModel = SearchCardViewModel()

    self.simulateBookmarkButtonPressedEvents(at: 100)

    let observer = self.testScheduler.createObserver(SearchCardBookmarkAlert.self)
    viewModel.outputs.showBookmarkAlert.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    XCTAssertEqual(observer.events, [next(100, SearchCardBookmarkAlert.nameInput)])
  }

  func test_bookmarkButton_withoutLines_showsAlert() {
    self.searchManager.state = SearchCardState(page: .tram, selectedLines: [])
    self.viewModel = SearchCardViewModel()

    self.simulateBookmarkButtonPressedEvents(at: 100)

    let observer = self.testScheduler.createObserver(SearchCardBookmarkAlert.self)
    viewModel.outputs.showBookmarkAlert.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    XCTAssertEqual(observer.events, [next(100, SearchCardBookmarkAlert.noLinesSelected)])
  }

  func test_searchButton_startsTracking() {
    self.searchManager.state = SearchCardState(page: .tram, selectedLines: self.testLines)
    self.viewModel = SearchCardViewModel()

    self.simulateSearchButtonPressedEvents(at: 100)
    self.testScheduler.start()

    self.assertEqual(self.trackingManager.trackedLines, [self.testLines])
    XCTAssertEqual(self.trackingManager.startCount, 1)
  }

  func test_searchButton_closes() {
    self.viewModel = SearchCardViewModel()

    self.simulateSearchButtonPressedEvents(at: 100, 200)

    let observer = self.testScheduler.createObserver(Void.self)
    viewModel.outputs.shouldClose.drive(observer).disposed(by: self.disposeBag)
    self.testScheduler.start()

    self.assertEqual(observer.events, [next(100, ()), next(200, ())])
  }

  // MARK: - Alerts

  func test_closingApiAlert_delays_andUpdatesLines() {
    self.searchManager.state       = SearchCardState(page: .tram, selectedLines: [])
    self.apiManager.availableLines = Promise(value: self.testLines)
    self.viewModel = SearchCardViewModel()

    self.simulateApiAlertTryAgainButtonPressedEvents(at: 100)

    let observers = self.bindLineObserters()
    self.testScheduler.start()
    self.waitForLineResponse(1, timeout: AppInfo.Timings.FailedRequestDelay.lines + 1)

    self.assertEqual(observers.line.events,                [next(0, []), next(100, self.testLines)])
    XCTAssertEqual(observers.showApiErrorAlert.events,     [])
    XCTAssertEqual(observers.isLineSelectorVisible.events, [next(0, false), next(100, true)])
    XCTAssertEqual(observers.isPlaceholderVisible.events,  [next(0, true),  next(100, false)])
    self.assertApiOperationCount(availableLines: 1)
  }

  func test_enteringNameInBookmarkAlert_createsBookmark() {
    self.bookmarksManager.bookmarks = []
    self.searchManager.state = SearchCardState(page: .tram, selectedLines: self.testLines)
    self.viewModel = SearchCardViewModel()

    let bookmark = Bookmark(name: "Test", lines: self.testLines)
    self.simulateBookmarkAlertNameEnteredEvents(next(100, bookmark.name))
    self.testScheduler.start()

    XCTAssertEqual(self.bookmarksManager.bookmarks, [bookmark])
  }

  // MARK: - Close

  func test_close_savesState() {
    self.searchManager.state = SearchCardState(page: .tram, selectedLines: [])
    self.viewModel = SearchCardViewModel()

    let page = LineType.bus
    let line = Line(name: "Test", type: .bus,  subtype: .express)

    self.simulatePageSelectedEvents(next(100, page))
    self.simulateLineSelectedEvents(next(200, line))

    self.simulateViewDidDisappearEvents(at: 300)
    self.testScheduler.start()

    XCTAssertEqual(self.searchManager.state, SearchCardState(page: page, selectedLines: [line]))
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

  typealias BookmarkAlertNameEnteredEvent = Recorded<Event<String>>

  func simulateBookmarkAlertNameEnteredEvents(_ events: BookmarkAlertNameEnteredEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.bookmarkAlertNameEntered)
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

  // MARK: - Lines observer

  private struct LinesObserver {
    let line:                  TestableObserver<[Line]>
    let showApiErrorAlert:     TestableObserver<SearchCardApiError>
    let isLineSelectorVisible: TestableObserver<Bool>
    let isPlaceholderVisible:  TestableObserver<Bool>
  }

  private func bindLineObserters() -> LinesObserver {
    let lineObserver = self.testScheduler.createObserver([Line].self)
    self.viewModel.outputs.lines.drive(lineObserver).disposed(by: self.disposeBag)

    let showApiErrorAlertObserver = self.testScheduler.createObserver(SearchCardApiError.self)
    self.viewModel.outputs.showApiErrorAlert.drive(showApiErrorAlertObserver).disposed(by: self.disposeBag)

    let isLineSelectorVisibleObserver = self.testScheduler.createObserver(Bool.self)
    self.viewModel.outputs.isLineSelectorVisible.drive(isLineSelectorVisibleObserver).disposed(by: self.disposeBag)

    let isPlaceholderVisibleObserver = self.testScheduler.createObserver(Bool.self)
    self.viewModel.outputs.isPlaceholderVisible.drive(isPlaceholderVisibleObserver).disposed(by: self.disposeBag)

    return LinesObserver(line:                  lineObserver,
                         showApiErrorAlert:     showApiErrorAlertObserver,
                         isLineSelectorVisible: isLineSelectorVisibleObserver,
                         isPlaceholderVisible:  isPlaceholderVisibleObserver)
  }

  // MARK: - Blocking

  /// Waif for PromiseKit dispatch_async response
  private func waitForLineResponse(_ count: Int, timeout: RxTimeInterval? = 2) {
    let startsWith = 1
    let observable = self.viewModel.outputs.showApiErrorAlert.asObservable()
    self.wait(for: observable, timeout: timeout, count: startsWith + count)
  }

  /// Waif for PromiseKit dispatch_async response
  private func waitForApiErrorAlert(_ count: Int, timeout: RxTimeInterval? = 2) {
    let observable = self.viewModel.outputs.showApiErrorAlert.asObservable()
    self.wait(for: observable, timeout: timeout, count: count)
  }

  private func wait<Element>(for observable: Observable<Element>, timeout: RxTimeInterval?, count: Int) {
    _ = try? observable
      .take(count)
      .toBlocking(timeout: timeout)
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

  func assertEqual(_ lhs: [[Line]], _ rhs: [[Line]]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsLines, rhsLines) in zip(lhs, rhs) {
      XCTAssertEqual(lhsLines, rhsLines)
    }
  }

  func assertEqual(_ lhs: [LinesEvent], _ rhs: [LinesEvent]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
      XCTAssertEqual(lhsEvent.time, rhsEvent.time)
    }
  }
}
