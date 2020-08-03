// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
import ReSwift

// swiftlint:disable implicit_return

extension Middlewares {

  internal static func persistency(environment: Environment) -> Middleware<AppState> {
    return { dispatch, getState in
      return { next in
        return { action in

          let before = getState()
          next(action)
          let after = getState()

          saveBookmarksIfNeeded(environment: environment,
                                before: before,
                                after: after)
          saveSearchCardStateIfNeeded(environment: environment,
                                      before: before,
                                      after: after)
        }
      }
    }
  }
}

private func saveBookmarksIfNeeded(
  environment: Environment,
  before stateBefore: AppState?,
  after stateAfter: AppState?
) {
  guard let before = stateBefore?.bookmarks,
        let after  = stateAfter?.bookmarks
    else { return }

  if before != after {
    os_log("Saving bookmarks", log: environment.log.redux, type: .info)
    environment.storage.saveBookmarks(after)
  }
}

private func saveSearchCardStateIfNeeded(
  environment: Environment,
  before stateBefore: AppState?,
  after stateAfter: AppState?
) {
  guard let before = stateBefore?.searchCardState,
        let after  = stateAfter?.searchCardState
    else { return }

  if before != after {
    os_log("Saving search card state", log: environment.log.redux, type: .info)
    environment.storage.saveSearchCardState(after)
  }
}
