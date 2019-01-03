// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

public struct AppState: StateType {
  public var userData: UserDataState
  public var apiData:  ApiDataState

  public static func load(from storage: StorageManagerType) -> AppState {
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

public struct UserDataState {
  public var bookmarks:       [Bookmark]
  public var searchCardState: SearchCardState
  public var trackedLines:    [Line]
}

public struct ApiDataState {
  public var lines: ApiResponseState<[Line]> = .none
  public var vehicleLocations: ApiResponseState<[Vehicle]> = .none
}

public enum ApiResponseState<Data>: CustomStringConvertible {
  case none
  case inProgress
  case data(Data)
  case error(Error)

  public var description: String {
    switch self {
    case .none: return "none"
    case .inProgress: return "inProgress"
    case .data: return "data"
    case .error: return "error"
    }
  }
}
