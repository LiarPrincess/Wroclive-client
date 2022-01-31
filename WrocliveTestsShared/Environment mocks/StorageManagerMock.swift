// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
@testable import WrocliveFramework

// swiftlint:disable discouraged_optional_collection

public class StorageManagerMock: StorageManagerType {

  public private(set) var readBookmarksCount = 0
  public private(set) var writeBookmarksCount = 0

  public private(set) var readTrackedLinesCount = 0
  public private(set) var writeTrackedLinesCount = 0

  public private(set) var readSearchCardStateCount = 0
  public private(set) var writeSearchCardStateCount = 0

  // MARK: - Documents directory

  public var documentsDirectory = URL(fileURLWithPath: "DOCUMENTS_DIRECTORY")

  // MARK: - Bookmarks

  public var bookmarks = [Bookmark]()

  public func readBookmarks() -> [Bookmark]? {
    self.readBookmarksCount += 1
    return self.bookmarks
  }

  public func writeBookmarks(_ bookmarks: [Bookmark]) {
    self.writeBookmarksCount += 1
    self.bookmarks = bookmarks
  }

  // MARK: - Tracked lines

  public var trackedLines = [Line]()

  public func readTrackedLines() -> [Line]? {
    self.readTrackedLinesCount += 1
    return self.trackedLines
  }

  public func writeTrackedLines(_ lines: [Line]) {
    self.writeTrackedLinesCount += 1
    self.trackedLines = lines
  }

  // MARK: - Search card state

  public var searchCardState = SearchCardState(page: .tram, selectedLines: [])

  public func readSearchCardState() -> SearchCardState? {
    self.readSearchCardStateCount += 1
    return self.searchCardState
  }

  public func writeSearchCardState(_ state: SearchCardState) {
    self.writeSearchCardStateCount += 1
    self.searchCardState = state
  }
}
