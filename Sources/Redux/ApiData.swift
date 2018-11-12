// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import ReSwift

enum ApiResponseState<Data> {
  case none
  case inProgress
  case data(Data)
  case error(Error)
}

struct ApiDataState {
  var lines: ApiResponseState<[Line]>
}

/// This type of api action is intended for ApiMiddleware
enum ApiAction: Action {
  case updateLines
}

/// This type of api action is dispatched by ApiMiddleware
enum ApiResponseAction: Action {
  case setLines(ApiResponseState<[Line]>)
}

func apiDataReducer(action: Action, state: ApiDataState?) -> ApiDataState {
  return ApiDataState(
    lines: linesReducer(action: action, state: state?.lines)
  )
}

private func linesReducer(action: Action, state: ApiResponseState<[Line]>?) -> ApiResponseState<[Line]> {
  if case let ApiResponseAction.setLines(response) = action {
    return response
  }

  return state ?? .none
}
