// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

// swiftlint:disable implicit_return
// swiftlint:disable closure_body_length
// swiftlint:disable discouraged_optional_collection

extension AppState {

  public typealias ReducerType = (Action, AppState?) -> AppState

  public static func createReducer(environment: Environment) -> ReducerType {
    return { (action: Action, state: AppState?) -> AppState in
      return AppState(
        mapType: mapTypeReducer(
          action: action,
          state: state?.mapType,
          environment: environment
        ),
        userLocationAuthorization: userLocationAuthorizationReducer(
          action: action,
          state: state?.userLocationAuthorization,
          environment: environment
        ),

        bookmarks: bookmarksReducer(
          action: action,
          state: state?.bookmarks
        ),
        trackedLines: trackedLinesReducer(
          action: action,
          state: state?.trackedLines
        ),

        getLinesResponse: getLinesResponseReducer(
          action: action,
          state: state?.getLinesResponse
        ),
        getVehicleLocationsResponse: getVehicleLocationsResponseReducer(
          action: action,
          state: state?.getVehicleLocationsResponse
        )
      )
    }
  }
}

// MARK: - User location authorization

private func userLocationAuthorizationReducer(
  action: Action,
  state: UserLocationAuthorization?,
  environment: Environment
) -> UserLocationAuthorization {
  switch action {
  case let UserLocationAuthorizationAction.set(newState):
    return newState
  default:
    if let oldState = state {
      return oldState
    }

    let result = environment.userLocation.getAuthorizationStatus()
    return result
  }
}

// MARK: - User data

private func mapTypeReducer(action: Action,
                            state: MapType?,
                            environment: Environment) -> MapType {
  switch action {
  case let MapTypeAction.set(value):
    return value
  default:
    if let oldState = state {
      return oldState
    }

    // TODO: [Map] Read from env
    return .standard
  }
}

private func bookmarksReducer(action: Action, state: [Bookmark]?) -> [Bookmark] {
  var state = state ?? []

  switch action {
  case let BookmarksAction.add(name, lines):
    state.append(Bookmark(name: name, lines: lines))

  case let BookmarksAction.remove(index) where state.indices.contains(index):
    state.remove(at: index)

  case let BookmarksAction.move(from, to)
    where state.indices.contains(from) && state.indices.contains(to):

    let bookmark = state.remove(at: from)
    state.insert(bookmark, at: to)

  default:
    break
  }

  return state
}

private func trackedLinesReducer(action: Action, state: [Line]?) -> [Line] {
  switch action {
  case let TrackedLinesAction.startTracking(lines):
    return lines
  default:
    return state ?? []
  }
}

// MARK: - Responses

private func getLinesResponseReducer(
  action: Action,
  state: AppState.ApiResponseState<[Line]>?
) -> AppState.ApiResponseState<[Line]> {
  if case let ApiAction.setLines(response) = action {
    return response
  }

  return state ?? .none
}

private func getVehicleLocationsResponseReducer(
  action: Action,
  state: AppState.ApiResponseState<[Vehicle]>?
) -> AppState.ApiResponseState<[Vehicle]> {
  if case let ApiAction.setVehicleLocations(response) = action {
    return response
  }

  return state ?? .none
}
