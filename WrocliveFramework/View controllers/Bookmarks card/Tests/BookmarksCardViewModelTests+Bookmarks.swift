// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import WrocliveFramework

extension BookmarksCardViewModelTests {

  func test_takesBookmarks_fromStore() {
    let initalBookmarks = self.testData
    let chagedBookmarks = [initalBookmarks[0], initalBookmarks[2]]

    self.setBookmarks(initalBookmarks)
    self.viewModel = BookmarksCardViewModel(self.store)

    self.scheduler.scheduleAt(100) { self.setBookmarks(chagedBookmarks) }

    let observer = self.scheduler.createObserver([Bookmark].self)
    viewModel.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    let expectedEvents = [next(0, initalBookmarks), next(100, chagedBookmarks)]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertEqual(self.storageMock.getBookmarksCount, 0) // we should get them from store
    XCTAssertEqual(self.storageMock.saveBookmarksCount, 0)
  }

  func test_movingItem_dispatchesMoveAction() {
    self.setBookmarks(self.testData)
    self.viewModel = BookmarksCardViewModel(self.store)

    let event0 = next(100, (from: 0, to: 2))
    let event1 = next(200, (from: 1, to: 0))
    self.simulateMoveEvents(event0, event1)

    let observer = self.scheduler.createObserver([Bookmark].self)
    viewModel.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 2)

    if case let BookmarksAction.move(from: from, to: to) = self.dispatchedActions[0] {
      XCTAssertEqual(from, 0)
      XCTAssertEqual(to, 2)
    }
    else { XCTAssert(false, "Invalid action type") }

    if case let BookmarksAction.move(from: from, to: to) = self.dispatchedActions[1] {
      XCTAssertEqual(from, 1)
      XCTAssertEqual(to, 0)
    }
    else { XCTAssert(false, "Invalid action type") }

    XCTAssertEqual(self.storageMock.getBookmarksCount, 0)
    XCTAssertEqual(self.storageMock.saveBookmarksCount, 0)
  }

  func test_deletingItem_dispatchesRemoveAction() {
    self.setBookmarks(self.testData)
    self.viewModel = BookmarksCardViewModel(self.store)

    let event0 = next(100, 0)
    let event1 = next(200, 2)
    self.simulateDeleteEvents(event0, event1)

    let observer = self.scheduler.createObserver([Bookmark].self)
    viewModel.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 2)

    if case let BookmarksAction.remove(at: index) = self.dispatchedActions[0] {
      XCTAssertEqual(index, 0)
    }
    else { XCTAssert(false, "Invalid action type") }

    if case let BookmarksAction.remove(at: index) = self.dispatchedActions[1] {
      XCTAssertEqual(index, 2)
    }
    else { XCTAssert(false, "Invalid action type") }

    XCTAssertEqual(self.storageMock.getBookmarksCount, 0)
    XCTAssertEqual(self.storageMock.saveBookmarksCount, 0)
  }
}
