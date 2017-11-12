//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class BookmarksManagerMock: BookmarksManager {

  // MARK: - Properties

  private var bookmarks: [Bookmark]

  // MARK: Init

  init(_ bookmarks: [Bookmark]) {
    self.bookmarks = bookmarks
  }

  // MARK: - BookmarksManager

  @discardableResult
  func addNew(name: String, lines: [Line]) -> Bookmark {
    let bookmark = Bookmark(name: name, lines: lines)

    var bookmarks = self.bookmarks
    bookmarks.append(bookmark)
    return bookmark
  }

  func getAll() -> [Bookmark] {
    return self.bookmarks
  }

  func save(_ bookmarks: [Bookmark]) {
    self.bookmarks = bookmarks
  }
}
