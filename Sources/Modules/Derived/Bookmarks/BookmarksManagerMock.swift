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

  func addNew(_ bookmark: Bookmark) {
    self.bookmarks.append(bookmark)
  }

  func getAll() -> [Bookmark] {
    return self.bookmarks
  }

  func save(_ bookmarks: [Bookmark]) {
    self.bookmarks = bookmarks
  }
}
