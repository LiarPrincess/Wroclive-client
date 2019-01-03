// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import WrocliveFramework

extension BookmarksCardViewModelTests {

  func test_withoutBookmarks_showsPlaceholder() {
    self.setBookmarks([])
    self.viewModel = BookmarksCardViewModel(self.store)

    let placeholderObserver = self.scheduler.createObserver(Bool.self)
    viewModel.isPlaceholderVisible
      .drive(placeholderObserver)
      .disposed(by: self.disposeBag)

    let tableViewObserver = self.scheduler.createObserver(Bool.self)
    viewModel.isTableViewVisible
      .drive(tableViewObserver)
      .disposed(by: self.disposeBag)

    self.startScheduler()

    let expectedPlaceholderEvents = [next(0, true)]
    XCTAssertEqual(placeholderObserver.events, expectedPlaceholderEvents)

    let expectedTableViewEvents = self.oppositeVisibility(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  func test_withBookmarks_showsTableView() {
    self.setBookmarks(self.testData)
    self.viewModel = BookmarksCardViewModel(self.store)

    let placeholderObserver = self.scheduler.createObserver(Bool.self)
    viewModel.isPlaceholderVisible
      .drive(placeholderObserver)
      .disposed(by: self.disposeBag)

    let tableViewObserver = self.scheduler.createObserver(Bool.self)
    viewModel.isTableViewVisible
      .drive(tableViewObserver)
      .disposed(by: self.disposeBag)

    self.startScheduler()

    let expectedPlaceholderEvents = [next(0, false)]
    XCTAssertEqual(placeholderObserver.events, expectedPlaceholderEvents)

    let expectedTableViewEvents = self.oppositeVisibility(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  func test_deletingBookmarks_showsPlaceholder() {
    self.setBookmarks(self.testData)
    self.viewModel = BookmarksCardViewModel(self.store)

    self.scheduler.scheduleAt(100) { self.setBookmarks([self.testData[1]]) }
    self.scheduler.scheduleAt(200) { self.setBookmarks([]) }

    let placeholderObserver = self.scheduler.createObserver(Bool.self)
    viewModel.isPlaceholderVisible
      .drive(placeholderObserver)
      .disposed(by: self.disposeBag)

    let tableViewObserver = self.scheduler.createObserver(Bool.self)
    viewModel.isTableViewVisible
      .drive(tableViewObserver)
      .disposed(by: self.disposeBag)

    self.startScheduler()

    let expectedPlaceholderEvents = [next(0, false), next(100, false), next(200, true)]
    XCTAssertEqual(placeholderObserver.events, expectedPlaceholderEvents)

    let expectedTableViewEvents = self.oppositeVisibility(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  typealias VisiblityEvent = Recorded<Event<Bool>>

  func oppositeVisibility(_ events: [VisiblityEvent]) -> [VisiblityEvent] {
    return events.map { next($0.time, !$0.value.element!) }
  }
}
