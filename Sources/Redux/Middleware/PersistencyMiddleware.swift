// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
import ReSwift

func createPersistencyMiddleware(storage: StorageManagerType, log: OSLog) -> Middleware<AppState> {
  return { dispatch, getState in
    return { next in
      return { action in
        let before = getState()
        next(action)
        let after = getState()

        saveBookmarksIfNeeded(before, after, to: storage, log)
        saveSearchCardStateIfNeeded(before, after, to: storage, log)
      }
    }
  }
}

private func saveBookmarksIfNeeded(_ stateBefore: AppState?, _ stateAfter: AppState?, to storage: StorageManagerType, _ log: OSLog) {
  guard let before = stateBefore?.userData.bookmarks,
        let after  = stateAfter?.userData.bookmarks
    else { return }

  if before != after {
    os_log("Saving bookmarks", log: log, type: .info)
    storage.saveBookmarks(after)
  }
}

private func saveSearchCardStateIfNeeded(_ stateBefore: AppState?, _ stateAfter: AppState?, to storage: StorageManagerType, _ log: OSLog) {
  guard let before = stateBefore?.userData.searchCardState,
        let after  = stateAfter?.userData.searchCardState
    else { return }

  if before != after {
    os_log("Saving search card state", log: log, type: .info)
    storage.saveSearchCardState(after)
  }
}
