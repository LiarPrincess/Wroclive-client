//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class BookmarksManagerAssert: BookmarksManager {

  func addNew(name: String, lines: [Line]) -> Bookmark {
    assertNotCalled()
  }

  func getAll() -> [Bookmark] {
    assertNotCalled()
  }

  func save(_ bookmarks: [Bookmark]) {
    assertNotCalled()
  }
}
