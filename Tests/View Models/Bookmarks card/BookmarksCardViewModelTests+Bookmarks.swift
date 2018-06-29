// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

extension BookmarksCardViewModelTests {

  func test_startsWithBookmarks_fromManager() {
    let bookmarks = self.testData
    self.storageManager._bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let observer = self.scheduler.createObserver([Bookmark].self)
    viewModel.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    let expectedEvents = [next(0, bookmarks)]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.storageManager, getBookmarks: 1, saveBookmarks: 0)
  }

  func test_movingItem_updatesBookmarks() {
    let bookmarks = self.testData
    self.storageManager._bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let event0 = next(100, (from: 0, to: 2))
    let event1 = next(200, (from: 1, to: 0))
    self.simulateMoveEvents(event0, event1)

    let observer = self.scheduler.createObserver([Bookmark].self)
    viewModel.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    let expectedEvents = [
      next(  0, bookmarks),
      next(100, [bookmarks[1], bookmarks[2], bookmarks[0]]),
      next(200, [bookmarks[2], bookmarks[1], bookmarks[0]])
    ]

    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertEqual(self.storageManager._bookmarks, expectedEvents.last!.value.element!)
    XCTAssertOperationCount(self.storageManager, getBookmarks: 1, saveBookmarks: 2)
  }

  func test_deletingItem_updatesBookmarks() {
    let bookmarks = self.testData
    self.storageManager._bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let event0 = next(100, 1) // middle
    let event1 = next(200, 1) // last
    let event2 = next(300, 0) // first
    self.simulateDeleteEvents(event0, event1, event2)

    let observer = self.scheduler.createObserver([Bookmark].self)
    viewModel.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    let expectedEvents = [
      next(  0, bookmarks),
      next(100, [bookmarks[0], bookmarks[2]]),
      next(200, [bookmarks[0]]),
      next(300, [])
    ]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertEqual(self.storageManager._bookmarks, expectedEvents.last!.value.element!)
    XCTAssertOperationCount(self.storageManager, getBookmarks: 1, saveBookmarks: 3)
  }
}
