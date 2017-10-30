//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class BookmarksManagerImpl: BookmarksManager {

  // MARK: - Properties

  private lazy var bookmarks: [Bookmark] = {
    let fileContent = Managers.documents.read(.bookmarks)
    return fileContent as? [Bookmark] ?? []
  }()

  // MARK: - Methods

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
    self.bookmarks = bookmarks
    Managers.documents.write(self.bookmarks, as: .bookmarks)
  }
}
