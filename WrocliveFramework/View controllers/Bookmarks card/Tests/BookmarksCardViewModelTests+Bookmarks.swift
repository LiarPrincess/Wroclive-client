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
    let changedBookmarks = [initalBookmarks[0], initalBookmarks[2]]

    self.setBookmarks(initalBookmarks)
    self.scheduler.scheduleAt(100) { self.setBookmarks(changedBookmarks) }

    self.viewModel = BookmarksCardViewModel(self.store)

    let observer = self.scheduler.createObserver([Bookmark].self)
    self.viewModel.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    XCTAssertEqual(observer.events, [
      Recorded.next(0, initalBookmarks),
      Recorded.next(100, changedBookmarks)
    ])

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
    self.viewModel.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 2)

    let move0 = self.getBookmarksMoveAction(at: 0)
    XCTAssertEqual(move0?.0, 0)
    XCTAssertEqual(move0?.1, 2)

    let move1 = self.getBookmarksMoveAction(at: 1)
    XCTAssertEqual(move1?.0, 1)
    XCTAssertEqual(move1?.1, 0)

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
    self.viewModel.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 2)
    XCTAssertEqual(self.getBookmarksRemoveAction(at: 0), 0)
    XCTAssertEqual(self.getBookmarksRemoveAction(at: 1), 2)

    XCTAssertEqual(self.storageMock.getBookmarksCount, 0)
    XCTAssertEqual(self.storageMock.saveBookmarksCount, 0)
  }
}
