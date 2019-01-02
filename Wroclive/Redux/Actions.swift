// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

enum BookmarksAction: Action {
  case add(name: String, lines: [Line])
  case remove(at: Int)
  case move(from: Int, to: Int)
}

enum SearchCardStateAction: Action {
  case selectPage(LineType)
  case selectLine(Line)
  case deselectLine(Line)
}

enum TrackedLinesAction: Action {
  case startTracking([Line])
}

/// This type of api action is intended for ApiMiddleware
enum ApiAction: Action {
  case updateLines
  case updateVehicleLocations
}

/// This type of api action is dispatched by ApiMiddleware
enum ApiResponseAction: Action {
  case setLines(ApiResponseState<[Line]>)
  case setVehicleLocations(ApiResponseState<[Vehicle]>)
}
