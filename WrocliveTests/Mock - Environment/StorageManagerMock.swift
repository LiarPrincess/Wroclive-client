// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
@testable import WrocliveFramework

class StorageManagerMock: StorageManagerType {

  private(set) var readBookmarksCount = 0
  private(set) var writeBookmarksCount = 0

  private(set) var readTrackedLinesCount = 0
  private(set) var writeTrackedLinesCount = 0

  private(set) var readSearchCardStateCount = 0
  private(set) var writeSearchCardStateCount = 0

  // MARK: - Documents directory

  var documentsDirectory = URL(fileURLWithPath: "DOCUMENTS_DIRECTORY")

  // MARK: - Bookmarks

  var bookmarks = [Bookmark]()

  func readBookmarks() -> [Bookmark]? {
    self.readBookmarksCount += 1
    return self.bookmarks
  }

  func writeBookmarks(_ bookmarks: [Bookmark]) {
    self.writeBookmarksCount += 1
    self.bookmarks = bookmarks
  }

  // MARK: - Tracked lines

  var trackedLines = [Line]()

  func readTrackedLines() -> [Line]? {
    self.readTrackedLinesCount += 1
    return self.trackedLines
  }

  func writeTrackedLines(_ lines: [Line]) {
    self.writeTrackedLinesCount += 1
    self.trackedLines = lines
  }

  // MARK: - Search card state

  var searchCardState = SearchCardState(page: .tram, selectedLines: [])

  func readSearchCardState() -> SearchCardState? {
    self.readSearchCardStateCount += 1
    return self.searchCardState
  }

  func writeSearchCardState(_ state: SearchCardState) {
    self.writeSearchCardStateCount += 1
    self.searchCardState = state
  }
}
