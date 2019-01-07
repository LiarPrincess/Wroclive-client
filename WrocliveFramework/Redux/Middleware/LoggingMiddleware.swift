// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
import ReSwift

public func createLoggingMiddleware() -> Middleware<AppState> {
  return createSingleMiddleware { _, _, next, action in
    os_log("%{public}@", log: AppEnvironment.log.redux, type: .info, String(describing: action))
    next(action)
  }
}