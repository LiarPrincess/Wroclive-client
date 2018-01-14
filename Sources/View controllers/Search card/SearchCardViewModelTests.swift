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

  // MARK: - State

  func test_showsSavedState() {
  }

  // MARK: - Page

  func test_selectingPage_updatesPage() {
    self.searchManager.searchState = SearchState(withSelected: .tram, lines: [])
    self.viewModel = SearchCardViewModel()

    let type0 = next( 50, LineType.bus)
    let type1 = next(150, LineType.tram)
    self.simulatePageSelectedEvents(type0, type1)

    let line0 = next(100, LineType.tram)
    let line1 = next(200, LineType.bus)
    self.simulatePageDidTransitionEvents(line0, line1)

    let observer = self.testScheduler.createObserver(LineType.self)
    self.viewModel.outputs.page
      .drive(observer)
      .disposed(by: self.disposeBag)
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

  // MARK: - Lines

  func test_appearing_updatesLines() {
    // lines      update
    // lineErrors no changes
    // isLineSelectorVisible update
    // isPlaceholderVisible  update
  }

  func test_closingApiAlert_delays_andUpdatesLines() {
    // lines      update
    // lineErrors no changes
    // isLineSelectorVisible update
    // isPlaceholderVisible  update
  }

  func test_requestingLines_withoutInternet_showsAlert() {
    // lines      no changes
    // lineErrors update
  }

  func test_requestingLines_onError_showsAlert() {
    // lines      no changes
    // lineErrors update
  }

  // MARK: - Buttons

  func test_bookmarkButton_withLines_createsBookmark() {
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

  // MARK: - Close

  func test_close_savesState() {
    self.searchManager.searchState = SearchState(withSelected: .bus, lines: [])
    self.viewModel = SearchCardViewModel()

    self.simulateViewDidDisappearEvents(at: 300)
    self.testScheduler.start()

    let expected = SearchState(withSelected: .bus, lines: [])
    XCTAssertEqual(expected, self.searchManager.getState())
    self.assertSearchOperationCount(get: 1, save: 1)
  }
}

// MARK: - Helpers

extension SearchCardViewModelTests {

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

  // MARK: - Asserts

  typealias VoidEvent = Recorded<Event<Void>>

  func assertSearchOperationCount(get: Int, save: Int) {
    XCTAssertEqual(self.searchManager.getStateCount, get)
    XCTAssertEqual(self.searchManager.saveCount, save)
  }

  func assertEqual(_ lhs: [VoidEvent], _ rhs: [VoidEvent]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
      XCTAssertEqual(lhsEvent.time, rhsEvent.time)
    }
  }
}
