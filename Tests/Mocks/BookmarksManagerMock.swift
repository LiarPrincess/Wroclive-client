//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
@testable import Wroclive

class BookmarksManagerMock: BookmarksManagerType {

  var bookmarks = [Bookmark]()

  init(bookmarks: [Bookmark]) {
    self.bookmarks = bookmarks
  }

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
