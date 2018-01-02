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

private typealias TextStyles = LineSelectionCellConstants.TextStyles

final class SearchViewModelTests: XCTestCase {

  // MARK: - Properties

  var trackingManager: TrackingManagerMock!
  var searchManager:   SearchManagerMock!
  var apiManager:      ApiManagerMock!

  var viewModel:     SearchViewModel!
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

  func test_emitsPage_onPageChange() {
    self.searchManager.searchState = SearchState(withSelected: .tram, lines: [])
    self.viewModel = SearchViewModel()

    let type0 = next( 50, LineType.bus)
    let type1 = next(150, LineType.tram)
    self.simulateLineTypeSelectorPageChangedEvents(type0, type1)

    let line0 = next(100, LineType.tram)
    let line1 = next(200, LineType.bus)
    self.simulateLineSelectorPageChangedEvents(line0, line1)

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

  // lines -> lines, isLineSelectorVisible, isPlaceholderVisible

  // MARK: - Buttons

  // TODO: bookmarkButtonPressed -> nothing
  func test_doesNothing_onBookmarkButtonPressed() {
  }

  // TODO: selected lines <- self.testLines
  func test_startsTracking_onSearchButtonPressedPressed() {
//    let bookmarks = self.testData
//    self.bookmarksManager.bookmarks = bookmarks
//    self.viewModel = BookmarksViewModel()
//
//    let event0 = next(100, IndexPath(item: 0, section: 0)) // first
//    let event1 = next(200, IndexPath(item: 1, section: 0)) // middle
//    self.simulateSelectionEvents(event0, event1)
//
//    self.testScheduler.start()
//
//    let expectedLines = [bookmarks[0].lines, bookmarks[1].lines]
//    self.assertEqual(self.trackingManager.requestedLines, expectedLines)
  }

  func test_closes_onSearchButtonPressedPressed() {
    self.viewModel = SearchViewModel()

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

  // TODO: selected lines <- self.testLines
  func test_savesState_onClose() {
    self.searchManager.searchState = SearchState(withSelected: .tram, lines: [])
    self.viewModel = SearchViewModel()

    self.simulateLineTypeSelectorPageChangedEvents(next(100, LineType.bus))
    // self.simulateSlectedLinesEvents()

    self.simulateDidCloseEvents(at: 300)
    self.testScheduler.start()

    let expected = SearchState(withSelected: .bus, lines: [])
    XCTAssertEqual(expected, self.searchManager.getState())
    self.assertSearchOperationCount(get: 1, save: 1)
  }
}
