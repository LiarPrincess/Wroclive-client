//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct Managers {

  // MARK: - Bookmark

  private static var _bookmark: BookmarksManager?

  static var bookmark: BookmarksManager {
    get {
      guard let bookmark = _bookmark else {
        fatalError("Bookmark manager has not been registered!")
      }
      return bookmark
    }
    set { _bookmark = newValue }
  }

}
