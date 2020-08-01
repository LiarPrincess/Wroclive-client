// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

public func apiDataReducer(action: Action,
                           state: AppState.ApiData?) -> AppState.ApiData {
  return AppState.ApiData(
    lines: linesReducer(action: action, state: state?.lines),
    vehicleLocations: vehicleLocationsReducer(action: action, state: state?.vehicleLocations)
  )
}

private func linesReducer(
  action: Action,
  state: AppState.ApiResponseState<[Line]>?
) -> AppState.ApiResponseState<[Line]> {
  if case let ApiResponseAction.setLines(response) = action {
    return response
  }

  return state ?? .none
}

private func vehicleLocationsReducer(
  action: Action,
  state: AppState.ApiResponseState<[Vehicle]>?
) -> AppState.ApiResponseState<[Vehicle]> {
  if case let ApiResponseAction.setVehicleLocations(response) = action {
    return response
  }

  return state ?? .none
}
