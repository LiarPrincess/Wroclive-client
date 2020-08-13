// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

extension BookmarksCardViewModelTests {

  func test_withoutBookmarks_showsPlaceholder() {
    self.setBookmarks([])
    let viewModel = self.createViewModel()

    XCTAssertEqual(self.refreshCallCount, 0)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertFalse(viewModel.isTableViewVisible)
  }

  func test_withBookmarks_showsTableView() {
    self.setBookmarks(self.testData)
    let viewModel = self.createViewModel()

    XCTAssertEqual(self.refreshCallCount, 0)
    XCTAssertFalse(viewModel.isPlaceholderVisible)
    XCTAssertTrue(viewModel.isTableViewVisible)
  }

  func test_deletingBookmarks_showsPlaceholder() {
    self.setBookmarks(self.testData)
    let viewModel = self.createViewModel()

    XCTAssertEqual(self.refreshCallCount, 0)
    XCTAssertFalse(viewModel.isPlaceholderVisible)
    XCTAssertTrue(viewModel.isTableViewVisible)

    let singleBookmark = [self.testData[1]]
    self.setBookmarks(singleBookmark)
    XCTAssertEqual(self.refreshCallCount, 1)
    XCTAssertFalse(viewModel.isPlaceholderVisible)
    XCTAssertTrue(viewModel.isTableViewVisible)

    let noBookmarks = [Bookmark]()
    self.setBookmarks(noBookmarks)
    XCTAssertEqual(self.refreshCallCount, 2)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertFalse(viewModel.isTableViewVisible)
  }
}
