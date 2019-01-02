// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
import ReSwift

func createPersistencyMiddleware() -> Middleware<AppState> {
  return createSingleMiddleware { _, getState, next, action in
    let before = getState()
    next(action)
    let after = getState()

    saveBookmarksIfNeeded(before, after)
    saveSearchCardStateIfNeeded(before, after)
  }
}

private func saveBookmarksIfNeeded(_ stateBefore: AppState?, _ stateAfter: AppState?) {
  guard let before = stateBefore?.userData.bookmarks,
        let after  = stateAfter?.userData.bookmarks
    else { return }

  if before != after {
    os_log("Saving bookmarks", log: AppEnvironment.log.storage, type: .info)
    AppEnvironment.storage.saveBookmarks(after)
  }
}

private func saveSearchCardStateIfNeeded(_ stateBefore: AppState?, _ stateAfter: AppState?) {
  guard let before = stateBefore?.userData.searchCardState,
        let after  = stateAfter?.userData.searchCardState
    else { return }

  if before != after {
    os_log("Saving search card state", log: AppEnvironment.log.storage, type: .info)
    AppEnvironment.storage.saveSearchCardState(after)
  }
}
