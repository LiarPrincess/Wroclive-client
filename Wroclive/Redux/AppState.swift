// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

struct AppState: StateType {
  var userData: UserDataState
  var apiData:  ApiDataState

  static func load(from storage: StorageManagerType) -> AppState {
    return AppState(
      userData: UserDataState(
        bookmarks: storage.loadBookmarks() ?? [],
        searchCardState: storage.loadSearchCardState() ?? .default,
        trackedLines: []
      ),
      apiData: ApiDataState()
    )
  }
}

struct UserDataState {
  var bookmarks:       [Bookmark]
  var searchCardState: SearchCardState
  var trackedLines:    [Line]
}

struct ApiDataState {
  var lines: ApiResponseState<[Line]> = .none
  var vehicleLocations: ApiResponseState<[Vehicle]> = .none
}

enum ApiResponseState<Data>: CustomDebugStringConvertible {
  case none
  case inProgress
  case data(Data)
  case error(Error)

  var debugDescription: String {
    switch self {
    case .none: return "none"
    case .inProgress: return "inProgress"
    case .data: return "data"
    case .error: return "error"
    }
  }
}
