//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State

struct BookmarksState {
  var bookmarks = [Bookmark]()
}

//MARK: - Actions

struct AddBookmark: Action {
  let bookmark: Bookmark

  init(_ bookmark: Bookmark) {
    self.bookmark = bookmark
  }
}

struct RemoveBookmark: Action {
  let bookmark: Bookmark

  init(_ bookmark: Bookmark) {
    self.bookmark = bookmark
  }
}

struct MoveBookmark: Action {
  let bookmark: Bookmark
  let position: Int

  init(_ bookmark: Bookmark, to position: Int) {
    self.bookmark = bookmark
    self.position = position
  }
}

//MARK: - Reducer

struct BookmarksReducer {

  func handleAction(action: Action, state: BookmarksState) -> BookmarksState {
    var state = state;
    switch action {

    case let action as AddBookmark:
      state.bookmarks.append(action.bookmark)
    case let action as RemoveBookmark:
      if let index = state.bookmarks.index(of: action.bookmark) {
        state.bookmarks.remove(at: index)
      }

    default:
      break
    }

    return state
  }
  
}
