//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
@testable import Wroclive

class BookmarksManagerMock: BookmarksManagerType {

  var bookmarks = [Bookmark]()

  private(set) var addCount  = 0
  private(set) var getCount  = 0
  private(set) var saveCount = 0

  init(bookmarks: [Bookmark]) {
    self.bookmarks = bookmarks
  }

  func add(_ bookmark: Bookmark) {
    self.addCount += 1
    self.bookmarks.append(bookmark)
  }

  func get() -> [Bookmark] {
    self.getCount += 1
    return self.bookmarks
  }

  func save(_ bookmarks: [Bookmark]) {
    self.saveCount += 1
    self.bookmarks = bookmarks
  }
}
