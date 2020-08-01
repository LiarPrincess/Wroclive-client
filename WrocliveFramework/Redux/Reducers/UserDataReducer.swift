// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

public func userDataReducer(action: Action,
                            state: AppState.UserData?) -> AppState.UserData {
  return AppState.UserData(
    bookmarks: bookmarksReducer(action: action, state: state?.bookmarks),
    trackedLines: trackedLinesReducer(action: action, state: state?.trackedLines),
    searchCardState: searchCardStateReducer(action: action, state: state?.searchCardState)
  )
}

private func bookmarksReducer(action: Action, state: [Bookmark]?) -> [Bookmark] {
  var state = state ?? []

  switch action {
  case let BookmarksAction.add(name, lines):
    state.append(Bookmark(name: name, lines: lines))

  case let BookmarksAction.remove(index) where state.indices.contains(index):
    state.remove(at: index)

  case let BookmarksAction.move(from, to)
    where state.indices.contains(from) && state.indices.contains(to):

    let bookmark = state.remove(at: from)
    state.insert(bookmark, at: to)

  default:
    break
  }

  return state
}

private func searchCardStateReducer(action: Action,
                                    state: SearchCardState?) -> SearchCardState {
  let state = state ?? .default

  switch action {
  case let SearchCardStateAction.selectPage(page):
    return SearchCardState(page: page, selectedLines: state.selectedLines)

  case let SearchCardStateAction.selectLine(line) where !state.selectedLines.contains(line):
    var lines = state.selectedLines
    lines.append(line)
    return SearchCardState(page: state.page, selectedLines: lines)

  case let SearchCardStateAction.deselectLine(line):
    let lines = state.selectedLines.filter { $0 != line }
    return SearchCardState(page: state.page, selectedLines: lines)

  default:
    return state
  }
}

private func trackedLinesReducer(action: Action, state: [Line]?) -> [Line] {
  switch action {
  case let TrackedLinesAction.startTracking(lines):
    return lines
  default:
    return state ?? []
  }
}
