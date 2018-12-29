//// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//// If a copy of the MPL was not distributed with this file,
//// You can obtain one at http://mozilla.org/MPL/2.0/.
//
//import XCTest
//import Foundation
//@testable import Wroclive
//
//class StorageManagerMock: StorageManagerType {
//
//  fileprivate var getBookmarksCount  = 0
//  fileprivate var saveBookmarksCount = 0
//
//  fileprivate var getSearchCardStateCount  = 0
//  fileprivate var saveSearchCardStateCount = 0
//
//  // MARK: - Bookmarks
//
//  var _bookmarks = [Bookmark]()
//
//  var bookmarks: [Bookmark] {
//    self.getBookmarksCount += 1
//    return self._bookmarks
//  }
//
//  func saveBookmarks(_ bookmarks: [Bookmark]) {
//    self.saveBookmarksCount += 1
//    self._bookmarks = bookmarks
//  }
//
//  func mockBookmarks(_ value: [Bookmark]) {
//    self._bookmarks = value
//  }
//
//  // MARK: - Search card
//
//  private var _searchCardState = SearchCardState(page: .tram, selectedLines: [])
//
//  var searchCardState: SearchCardState {
//    self.getSearchCardStateCount += 1
//    return self._searchCardState
//  }
//
//  func saveSearchCardState(_ state: SearchCardState) {
//    self.saveSearchCardStateCount += 1
//    self._searchCardState = state
//  }
//
//  func mockSearchCardState(_ value: SearchCardState) {
//    self._searchCardState = value
//  }
//
//  // MARK: - Assert
//
//  func assertBookmarks(_ value: [Bookmark],
//                       file:    StaticString = #file,
//                       line:    UInt         = #line) {
//    XCTAssertEqual(self._bookmarks, value, file: file, line: line)
//  }
//
//  func assertSearchCardStateOperation(_ value: SearchCardState,
//                                      file:    StaticString = #file,
//                                      line:    UInt         = #line) {
//    XCTAssertEqual(self._searchCardState, value, file: file, line: line)
//  }
//
//  func assertBookmarkOperationCount(get:  Int,
//                                    save: Int,
//                                    file: StaticString = #file,
//                                    line: UInt         = #line) {
//    XCTAssertEqual(self.getBookmarksCount,  get,  file: file, line: line)
//    XCTAssertEqual(self.saveBookmarksCount, save, file: file, line: line)
//  }
//
//  func assertSearchCardStateOperationCount(get:  Int,
//                                           save: Int,
//                                           file: StaticString = #file,
//                                           line: UInt         = #line) {
//    XCTAssertEqual(self.getSearchCardStateCount,  get,  file: file, line: line)
//    XCTAssertEqual(self.saveSearchCardStateCount, save, file: file, line: line)
//  }
//}
//
//func XCTAssertOperationCount(_ manager:      StorageManagerMock,
//                             getBookmarks:   Int,
//                             saveBookmarks:  Int,
//                             file: StaticString = #file,
//                             line: UInt         = #line) {
//  XCTAssertEqual(manager.getBookmarksCount,  getBookmarks,  file: file, line: line)
//  XCTAssertEqual(manager.saveBookmarksCount, saveBookmarks, file: file, line: line)
//}
