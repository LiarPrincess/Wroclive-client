//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

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
