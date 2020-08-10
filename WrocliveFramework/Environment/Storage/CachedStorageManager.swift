// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// Add cache layer to another `StorageManagerType`
public final class CachedStorageManager: StorageManagerType {

  private let inner: StorageManagerType

  private var bookmarks: [Bookmark]?
  private var trackedLines: [Line]?
  private var searchCardState: SearchCardState?

  public init(using inner: StorageManagerType) {
    self.inner = inner
  }

  public var documentsDirectory: URL {
    return self.inner.documentsDirectory
  }

  // MARK: - Read

  public func readBookmarks() -> [Bookmark]? {
    if self.bookmarks == nil {
      self.bookmarks = self.inner.readBookmarks()
    }

    return self.bookmarks
  }

  public func readTrackedLines() -> [Line]? {
    if self.trackedLines == nil {
      self.trackedLines = self.inner.readTrackedLines()
    }

    return self.trackedLines
  }

  public func readSearchCardState() -> SearchCardState? {
    if self.searchCardState == nil {
      self.searchCardState = self.inner.readSearchCardState()
    }

    return self.searchCardState
  }

  // MARK: - Write

  public func writeBookmarks(_ bookmarks: [Bookmark]) {
    self.bookmarks = bookmarks
    self.inner.writeBookmarks(bookmarks)
  }

  public func writeTrackedLines(_ lines: [Line]) {
    self.trackedLines = lines
    self.inner.writeTrackedLines(lines)
  }

  public func writeSearchCardState(_ state: SearchCardState) {
    self.searchCardState = state
    self.inner.writeSearchCardState(state)
  }
}
