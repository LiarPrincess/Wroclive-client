//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class BookmarksManager: BookmarksManagerType {

  func add(_ bookmark: Bookmark) {
    var bookmarks = self.get()
    bookmarks.append(bookmark)
    self.save(bookmarks)
  }

  func get() -> [Bookmark] {
    let document = Managers.documents.read(.bookmarks)
    return document as? [Bookmark] ?? []
  }

  func save(_ bookmarks: [Bookmark]) {
    let document = DocumentData.bookmarks(value: bookmarks)
    Managers.documents.write(document)
  }
}
