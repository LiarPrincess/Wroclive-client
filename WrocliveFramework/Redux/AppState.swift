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
        bookmarks: storage.getSavedBookmarks() ?? [],
        searchCardState: storage.getSavedSearchCardState() ?? .default,
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

public enum ApiResponseState<Data> {
  case none
  case inProgress
  case data(Data)
  case error(ApiError)
}
