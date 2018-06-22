// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

protocol StorageManagerType {

  /// Get saved bookmarks
  var bookmarks: [Bookmark] { get }

  /// Get saved search card state
  /// or default if no state were saved
  var searchCardState: SearchCardState { get }

  /// Replace saved bookmarks with @bookmarks
  func saveBookmarks(_ bookmarks: [Bookmark])

  /// Replace saved search card state with @state
  func saveSearchCardState(_ state: SearchCardState)
}

extension StorageManagerType {

  /// Add new @bookmark at the end of existing bookmarks
  func addBookmark(_ bookmark: Bookmark) {
    var bookmarks = self.bookmarks
    bookmarks.append(bookmark)
    self.saveBookmarks(bookmarks)
  }
}
