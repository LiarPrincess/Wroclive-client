// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

// swiftlint:disable implicit_return

extension Middlewares {

  internal static func api(environment: Environment) -> Middleware<AppState> {
    return { dispatch, getState in
      return { next in
        return { action in
          guard let state = getState() else {
            return
          }

          switch action {
          case ApiMiddlewareActions.requestLines:
            requestLines(environment: environment, dispatch: dispatch)

          case ApiMiddlewareActions.requestNotifications:
            requestNotifications(environment: environment, dispatch: dispatch)

          case ApiMiddlewareActions.requestVehicleLocations:
            requestVehicleLocations(environment: environment,
                                    state: state,
                                    dispatch: dispatch)
          default:
            next(action)
          }
        }
      }
    }
  }

  private static func requestLines(
    environment: Environment,
    dispatch: @escaping DispatchFunction
  ) {
    dispatch(ApiAction.setLines(.inProgress))

    _ = environment.api.getLines()
      .done { dispatch(ApiAction.setLines(.data($0))) }
      .catch { error in
        let apiError = Self.toApiError(error: error)
        dispatch(ApiAction.setLines(.error(apiError)))
      }
  }

  private static func requestNotifications(
    environment: Environment,
    dispatch: @escaping DispatchFunction
  ) {
    dispatch(ApiAction.setNotifications(.inProgress))

    _ = environment.api.getNotifications()
      .done { dispatch(ApiAction.setNotifications(.data($0))) }
      .catch { error in
        let apiError = Self.toApiError(error: error)
        dispatch(ApiAction.setNotifications(.error(apiError)))
      }
  }

  private static func requestVehicleLocations(
    environment: Environment,
    state: AppState,
    dispatch: @escaping DispatchFunction
  ) {
    let trackedLines = state.trackedLines

    guard trackedLines.any else {
      dispatch(ApiAction.setVehicleLocations(.data([])))
      return
    }

    dispatch(ApiAction.setVehicleLocations(.inProgress))

    _ = environment.api.getVehicleLocations(for: trackedLines)
      .done { dispatch(ApiAction.setVehicleLocations(.data($0))) }
      .catch { error in
        let apiError = toApiError(error: error)
        dispatch(ApiAction.setVehicleLocations(.error(apiError)))
      }
  }

  private static func toApiError(error: Error) -> ApiError {
    switch error {
    case ApiError.invalidResponse:
      return .invalidResponse
    case ApiError.reachabilityError:
      return .reachabilityError
    case ApiError.otherError(let e):
      return .otherError(e)
    default:
      return .otherError(error)
    }
  }
}
