// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
import ReSwift

// swiftlint:disable implicit_return

extension Middlewares {

  internal static func logging(environment: Environment) -> Middleware<AppState> {
    return { dispatch, getState in
      return { next in
        return { action in
          let log = environment.log.redux
          os_log("%{public}@", log: log, type: .info, String(describing: action))
          next(action)
        }
      }
    }
  }
}
