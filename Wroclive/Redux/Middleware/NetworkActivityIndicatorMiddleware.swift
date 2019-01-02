// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

func createNetworkActivityIndicatorMiddleware() -> Middleware<AppState> {
  return createSingleMiddleware { _, getState, next, action in
    next(action)

    if let state = getState() {
      let hasPending = hasPendingRequests(state)
      AppEnvironment.network.setNetworkActivityIndicatorVisibility(hasPending)
    }
  }
}

private func hasPendingRequests(_ state: AppState) -> Bool {
  if case .inProgress = state.apiData.lines {
    return true
  }

  if case .inProgress = state.apiData.vehicleLocations {
    return true
  }

  return false
}
