// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

extension BookmarksCardViewModelTests {

  func test_takesBookmarks_fromStore() {
    let initalBookmarks = self.testData
    let changedBookmarks = [initalBookmarks[0], initalBookmarks[2]]

    self.setBookmarks(initalBookmarks)
    let viewModel = self.createViewModel()
    XCTAssertEqual(viewModel.bookmarks, initalBookmarks)
    XCTAssertEqual(self.refreshCallCount, 0)

    self.setBookmarks(changedBookmarks)
    XCTAssertEqual(viewModel.bookmarks, changedBookmarks)
    XCTAssertEqual(self.refreshCallCount, 1)

    // We should get bookmarks from the store, not storage
    XCTAssertEqual(self.storageManager.readBookmarksCount, 0)
    XCTAssertEqual(self.storageManager.writeBookmarksCount, 0)
  }

  func test_movingItem_dispatchesMoveAction() {
    self.setBookmarks(self.testData)
    let viewModel = self.createViewModel()

    viewModel.viewDidMoveItem(fromIndex: 0, toIndex: 2)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    if let move = self.getMoveBookmarkAction(at: 0) {
      XCTAssertEqual(move.from, 0)
      XCTAssertEqual(move.to, 2)
    }

    viewModel.viewDidMoveItem(fromIndex: 1, toIndex: 0)
    XCTAssertEqual(self.dispatchedActions.count, 2)
    if let move = self.getMoveBookmarkAction(at: 1) {
      XCTAssertEqual(move.from, 1)
      XCTAssertEqual(move.to, 0)
    }

    // We should get bookmarks from the store, not storage
    XCTAssertEqual(self.storageManager.readBookmarksCount, 0)
    XCTAssertEqual(self.storageManager.writeBookmarksCount, 0)
  }

  func test_deletingItem_dispatchesRemoveAction() {
    self.setBookmarks(self.testData)
    let viewModel = self.createViewModel()

    viewModel.viewDidDeleteItem(index: 0)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    if let index = self.getRemoveBookmarkAction(at: 0) {
      XCTAssertEqual(index, 0)
    }

    viewModel.viewDidDeleteItem(index: 2)
    XCTAssertEqual(self.dispatchedActions.count, 2)
    if let index = self.getRemoveBookmarkAction(at: 1) {
      XCTAssertEqual(index, 2)
    }

    // We should get bookmarks from the store, not storage
    XCTAssertEqual(self.storageManager.readBookmarksCount, 0)
    XCTAssertEqual(self.storageManager.writeBookmarksCount, 0)
  }
}
