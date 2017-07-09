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

  // MARK: - Lines

  private static var _lines: LinesManager?

  static var lines: LinesManager {
    get {
      guard let lines = _lines else {
        fatalError("Lines manager has not been registered!")
      }
      return lines
    }
    set { _lines = newValue }
  }

  // MARK: - Search state

  private static var _searchState: SearchStateManager?

  static var searchState: SearchStateManager {
    get {
      guard let searchState = _searchState else {
        fatalError("Search state manager has not been registered!")
      }
      return searchState
    }
    set { _searchState = newValue }
  }

}
