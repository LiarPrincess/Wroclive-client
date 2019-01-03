// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public protocol StorageManagerType {

  /// Get saved bookmarks
  func loadBookmarks() -> [Bookmark]?

  /// Get saved search card state or default if no state were saved
  func loadSearchCardState() -> SearchCardState?

  /// Replace saved bookmarks with @bookmarks
  func saveBookmarks(_ bookmarks: [Bookmark])

  /// Replace saved search card state with @state
  func saveSearchCardState(_ state: SearchCardState)
}

// sourcery: manager
public final class StorageManager: StorageManagerType {

  private var _bookmarks:       [Bookmark]?
  private var _searchCardState: SearchCardState?
  private let _fileSystem     = FileSystem()

  public init() { }

  // MARK: - StorageManagerType

  public func loadBookmarks() -> [Bookmark]? {
    if self._bookmarks == nil {
      self._bookmarks = self.readDocument(.bookmarks) as? [Bookmark]
    }
    return self._bookmarks
  }

  public func loadSearchCardState() -> SearchCardState? {
    if self._searchCardState == nil {
      self._searchCardState = self.readDocument(.searchCardState) as? SearchCardState
    }
    return self._searchCardState
  }

  public func saveBookmarks(_ bookmarks: [Bookmark]) {
    self._bookmarks = bookmarks
    self.writeDocument(.bookmarks(bookmarks))
  }

  public func saveSearchCardState(_ state: SearchCardState) {
    self._searchCardState = state
    self.writeDocument(.searchCardState(state))
  }

  // MARK: - Document manager helpers

  private func readDocument(_ document: Document) -> Any? {
    return self._fileSystem.read(document)
  }

  private func writeDocument(_ document: DocumentData) {
    self._fileSystem.write(document)
  }
}
