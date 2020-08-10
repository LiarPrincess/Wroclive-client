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

          if let after = after?.bookmarks, after != before?.bookmarks {
            os_log("Saving bookmarks", log: environment.log.redux, type: .info)
            environment.storage.saveBookmarks(after)
          }

          // Add new entries here
        }
      }
    }
  }
}
