// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
@testable import Wroclive

class StorageManagerMock: StorageManagerType {

  fileprivate var getBookmarksCount  = 0
  fileprivate var saveBookmarksCount = 0

  fileprivate var getSearchCardStateCount  = 0
  fileprivate var saveSearchCardStateCount = 0

  var _bookmarks       = [Bookmark]()
  var _searchCardState = SearchCardState(page: .tram, selectedLines: [])

  var bookmarks: [Bookmark] {
    self.getBookmarksCount += 1
    return self._bookmarks
  }

  var searchCardState: SearchCardState {
    self.getSearchCardStateCount += 1
    return self._searchCardState
  }

  func saveBookmarks(_ bookmarks: [Bookmark]) {
    self.saveBookmarksCount += 1
    self._bookmarks = bookmarks
  }

  func saveSearchCardState(_ state: SearchCardState) {
    self.saveSearchCardStateCount += 1
    self._searchCardState = state
  }
}

func XCTAssertOperationCount(_ manager:      StorageManagerMock,
                             getBookmarks:   Int,
                             saveBookmarks:  Int,
                             file: StaticString = #file,
                             line: UInt         = #line) {
  XCTAssertEqual(manager.getBookmarksCount,  getBookmarks,  file: file, line: line)
  XCTAssertEqual(manager.saveBookmarksCount, saveBookmarks, file: file, line: line)
}

func XCTAssertOperationCount(_ manager:           StorageManagerMock,
                             getSearchCardState:  Int,
                             saveSearchCardState: Int,
                             file: StaticString = #file,
                             line: UInt         = #line) {
  XCTAssertEqual(manager.getSearchCardStateCount,  getSearchCardState,  file: file, line: line)
  XCTAssertEqual(manager.saveSearchCardStateCount, saveSearchCardState, file: file, line: line)
}
