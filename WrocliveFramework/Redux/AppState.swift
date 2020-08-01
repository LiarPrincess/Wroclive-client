// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

public struct AppState: StateType {

  public var userData: UserData
  public var apiData:  ApiData

  public struct UserData {
    public var bookmarks: [Bookmark]
    public var trackedLines: [Line]
    public var searchCardState: SearchCardState
  }

  public struct ApiData {
    public var lines: ApiResponseState<[Line]>
    public var vehicleLocations: ApiResponseState<[Vehicle]>
  }

  public enum ApiResponseState<Data> {
    case none
    case inProgress
    case data(Data)
    case error(ApiError)
  }

  public func load(
    from storage: StorageManagerType,
    defaultBookmarks: [Bookmark],
    defaultSavedSearchCardState: SearchCardState
  ) -> AppState {
    return AppState(
      userData: UserData(
        bookmarks: storage.getSavedBookmarks() ?? defaultBookmarks,
        trackedLines: [],
        searchCardState: storage.getSavedSearchCardState() ?? defaultSavedSearchCardState
      ),
      apiData: ApiData(
        lines: .none,
        vehicleLocations: .none
      )
    )
  }
}
