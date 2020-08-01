// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
import ReSwift

// swiftlint:disable implicit_return

public func createPersistencyMiddleware(env: Environment) -> Middleware<AppState> {
  return { dispatch, getState in
    return { next in
      return { action in

        let before = getState()
        next(action)
        let after = getState()

        saveBookmarksIfNeeded(env: env, before: before, after: after)
        saveSearchCardStateIfNeeded(env: env, before: before, after: after)
      }
    }
  }
}

private func saveBookmarksIfNeeded(
  env: Environment,
  before stateBefore: AppState?,
  after stateAfter: AppState?
) {
  guard let before = stateBefore?.userData.bookmarks,
        let after  = stateAfter?.userData.bookmarks
    else { return }

  if before != after {
    os_log("Saving bookmarks", log: env.log.storage, type: .info)
    env.storage.saveBookmarks(after)
  }
}

private func saveSearchCardStateIfNeeded(
  env: Environment,
  before stateBefore: AppState?,
  after stateAfter: AppState?
) {
  guard let before = stateBefore?.userData.searchCardState,
        let after  = stateAfter?.userData.searchCardState
    else { return }

  if before != after {
    os_log("Saving search card state", log: env.log.storage, type: .info)
    env.storage.saveSearchCardState(after)
  }
}
