// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

func apiDataReducer(action: Action, state: ApiDataState?) -> ApiDataState {
  return ApiDataState(
    lines: linesReducer(action: action, state: state?.lines),
    vehicleLocations: vehicleLocationsReducer(action: action, state: state?.vehicleLocations)
  )
}

private func linesReducer(action: Action, state: ApiResponseState<[Line]>?) -> ApiResponseState<[Line]> {
  if case let ApiResponseAction.setLines(response) = action {
    return response
  }

  return state ?? .none
}

private func vehicleLocationsReducer(action: Action, state: ApiResponseState<[Vehicle]>?) -> ApiResponseState<[Vehicle]> {
  if case let ApiResponseAction.setVehicleLocations(response) = action {
    return response
  }

  return state ?? .none
}
