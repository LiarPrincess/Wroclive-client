//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class BookmarksManagerImpl: BookmarksManager {

  // MARK: - Properties

  private var bookmarks: [Bookmark] {
    let fileContent = Managers.documents.read(.bookmarks)
    return fileContent as? [Bookmark] ?? []
  }

  // MARK: - BookmarksManager

  @discardableResult
  func addNew(name: String, lines: [Line]) -> Bookmark {
    let bookmark = Bookmark(name: name, lines: lines)

    var bookmarks = self.bookmarks
    bookmarks.append(bookmark)
    self.save(bookmarks)

    return bookmark
  }

  func getAll() -> [Bookmark] {
    return self.bookmarks
  }

  func save(_ bookmarks: [Bookmark]) {
    Managers.documents.write(bookmarks, as: .bookmarks)
  }
}
