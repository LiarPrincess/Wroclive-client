// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// Add cache layer to another `StorageManagerType`
public final class CachedStorageManager: StorageManagerType {

  private let inner: StorageManagerType

  private var bookmarks:       [Bookmark]?
  private var searchCardState: SearchCardState?

  public init(using inner: StorageManagerType) {
    self.inner = inner
  }

  public func getSavedBookmarks() -> [Bookmark]? {
    if self.bookmarks == nil {
      self.bookmarks = self.inner.getSavedBookmarks()
    }
    return self.bookmarks
  }

  public func getSavedSearchCardState() -> SearchCardState? {
    if self.searchCardState == nil {
      self.searchCardState = self.inner.getSavedSearchCardState()
    }
    return self.searchCardState
  }

  public func saveBookmarks(_ bookmarks: [Bookmark]) {
    self.bookmarks = bookmarks
    self.inner.saveBookmarks(bookmarks)
  }

  public func saveSearchCardState(_ state: SearchCardState) {
    self.searchCardState = state
    self.inner.saveSearchCardState(state)
  }
}
