// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

// swiftlint:disable implicit_return

extension Middlewares {

  internal static func networkActivityIndicator(
    environment: Environment
  ) -> Middleware<AppState> {

    return { dispatch, getState in
      return { next in
        return { action in

          // dispatch action and only later check if we have pending request
          next(action)

          if let state = getState() {
            let hasPending = hasPendingRequests(state)
            environment.api.setNetworkActivityIndicatorVisibility(isVisible: hasPending)
          }
        }
      }
    }
  }
}

private func hasPendingRequests(_ state: AppState) -> Bool {
  if case .inProgress = state.getLinesResponse {
    return true
  }

  if case .inProgress = state.getVehicleLocationsResponse {
    return true
  }

  return false
}
