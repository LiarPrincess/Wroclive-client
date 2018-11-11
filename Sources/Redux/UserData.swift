// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import ReSwift

struct UserDataState {
  var bookmarks: [Bookmark]
}

enum BookmarksAction: Action {
  case add(name: String, lines: [Line])
  case remove(at: Int)
  case move(from: Int, to: Int)
}

func userDataReducer(action: Action, state: UserDataState?) -> UserDataState {
  return UserDataState(
    bookmarks: bookmarksReducer(action: action, state: state?.bookmarks)
  )
}

private func bookmarksReducer(action: Action, state: [Bookmark]?) -> [Bookmark] {
  var state = state ?? dummyBookmarks()

  switch action {
  case BookmarksAction.add:
    print("BookmarksAction.add is not yet implemented!")
  case let BookmarksAction.remove(index) where state.indices.contains(index):
    state.remove(at: index)
  case let BookmarksAction.move(from, to) where state.indices.contains(from) && state.indices.contains(to):
    let bookmark = state.remove(at: from)
    state.insert(bookmark, at: to)
  default:
    break
  }

  return state
}

private func dummyBookmarks() -> [Bookmark] {
  let line0 = Line(name:  "1", type: .tram, subtype: .regular)
  let line1 = Line(name:  "4", type: .tram, subtype: .regular)
  let line2 = Line(name: "20", type: .tram, subtype: .regular)
  let line3 = Line(name:  "A", type:  .bus, subtype: .regular)
  let line4 = Line(name:  "D", type:  .bus, subtype: .regular)

  let bookmark0 = Bookmark(name: "Test 0", lines: [line0, line1, line2, line3, line4])
  let bookmark1 = Bookmark(name: "Test 1", lines: [line0, line2, line4])
  let bookmark2 = Bookmark(name: "Test 2", lines: [line0, line2, line3])

  return [
    bookmark0, bookmark1, bookmark2,
    bookmark0, bookmark1, bookmark2,
    bookmark0, bookmark1, bookmark2
  ]
}
