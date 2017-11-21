//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class BookmarksManagerImpl: BookmarksManager {

  func addNew(_ bookmark: Bookmark) {
    var bookmarks = self.getAll()
    bookmarks.append(bookmark)
    self.save(bookmarks)
  }

  func getAll() -> [Bookmark] {
    let document = Managers.documents.read(.bookmarks)
    return document as? [Bookmark] ?? []
  }

  func save(_ bookmarks: [Bookmark]) {
    let document = DocumentData.bookmarks(value: bookmarks)
    Managers.documents.write(document)
  }
}
