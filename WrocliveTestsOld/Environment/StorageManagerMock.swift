// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
@testable import WrocliveFramework

class StorageManagerMock: StorageManagerType {

  private(set) var getBookmarksCount  = 0
  private(set) var saveBookmarksCount = 0

  private(set) var getSearchCardStateCount  = 0
  private(set) var saveSearchCardStateCount = 0

  // MARK: - Bookmarks

  var bookmarks = [Bookmark]()

  func getSavedBookmarks() -> [Bookmark]? {
    self.getBookmarksCount += 1
    return self.bookmarks
  }

  func saveBookmarks(_ bookmarks: [Bookmark]) {
    self.saveBookmarksCount += 1
    self.bookmarks = bookmarks
  }

  // MARK: - Search card state

  private var searchCardState = SearchCardState(page: .tram, selectedLines: [])

  func getSavedSearchCardState() -> SearchCardState? {
    self.getSearchCardStateCount += 1
    return self.searchCardState
  }

  func saveSearchCardState(_ state: SearchCardState) {
    self.saveSearchCardStateCount += 1
    self.searchCardState = state
  }
}
