// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

class BookmarksCardViewModelVisibilityTests: BookmarksCardViewModelTestsBase {

  func test_withoutBookmarks_showsPlaceholder() {
    self.storageManager._bookmarks = []
    self.viewModel = BookmarksCardViewModel()

    let placeholderObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.isPlaceholderVisible
      .drive(placeholderObserver)
      .disposed(by: self.disposeBag)

    let tableViewObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.isTableViewVisible
      .drive(tableViewObserver)
      .disposed(by: self.disposeBag)

    self.testScheduler.start()

    let expectedPlaceholderEvents = [next(0, true)]
    XCTAssertEqual(placeholderObserver.events, expectedPlaceholderEvents)

    let expectedTableViewEvents = self.oppositeVisibility(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  func test_withAnyBookmarks_showsTableView() {
    self.storageManager._bookmarks = self.testData
    self.viewModel = BookmarksCardViewModel()

    let placeholderObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.isPlaceholderVisible
      .drive(placeholderObserver)
      .disposed(by: self.disposeBag)

    let tableViewObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.isTableViewVisible
      .drive(tableViewObserver)
      .disposed(by: self.disposeBag)

    self.testScheduler.start()

    let expectedPlaceholderEvents = [next(0, false)]
    XCTAssertEqual(placeholderObserver.events, expectedPlaceholderEvents)

    let expectedTableViewEvents = self.oppositeVisibility(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  func test_afterAllBookmarksDeleted_showsPlaceholder() {
    self.storageManager._bookmarks = self.testData
    self.viewModel = BookmarksCardViewModel()

    let event0 = next(100, 1) // middle
    let event1 = next(200, 1) // last
    let event2 = next(300, 0) // first
    self.simulateDeleteEvents(event0, event1, event2)

    let placeholderObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.isPlaceholderVisible
      .drive(placeholderObserver)
      .disposed(by: self.disposeBag)

    let tableViewObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.isTableViewVisible
      .drive(tableViewObserver)
      .disposed(by: self.disposeBag)

    self.testScheduler.start()

    let expectedPlaceholderEvents = [next(0, false), next(100, false), next(200, false), next(300, true)]
    XCTAssertEqual(placeholderObserver.events, expectedPlaceholderEvents)

    let expectedTableViewEvents = self.oppositeVisibility(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  typealias VisiblityEvent = Recorded<Event<Bool>>

  func oppositeVisibility(_ events: [VisiblityEvent]) -> [VisiblityEvent] {
    return events.map { next($0.time, !$0.value.element!) }
  }
}
