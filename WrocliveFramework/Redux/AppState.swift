// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

public struct AppState: StateType {

  public var userData: UserData
  public var apiData:  ApiData

  public struct UserData {
    public var userLocationAuthorization: UserLocationAuthorization
    public var bookmarks: [Bookmark]
    public var trackedLines: [Line]
    public var searchCardState: SearchCardState
  }

  public struct ApiData {
    public var lines: ApiResponseState<[Line]>
    public var vehicleLocations: ApiResponseState<[Vehicle]>
  }

  public enum ApiResponseState<Data> {
    /// No response recieved (yet).
    /// Default state, just after starting the app.
    case none
    /// Request was send, no response (yet).
    case inProgress
    case data(Data)
    case error(ApiError)

    public func getData() -> Data? {
      switch self {
      case .data(let d):
        return d
      case .none, .inProgress, .error:
        return nil
      }
    }

    public func getError() -> ApiError? {
      switch self {
      case .error(let e):
        return e
      case .none, .inProgress, .data:
        return nil
      }
    }
  }

  public static func load(
    from environment: Environment,
    bookmarksIfNotSaved: [Bookmark],
    searchCardStateIfNotSaved: SearchCardState
  ) -> AppState {
    let storage = environment.storage
    return AppState(
      userData: UserData(
        userLocationAuthorization: UserLocationManager.getAuthorizationStatus(),
        bookmarks: storage.getSavedBookmarks()  ?? bookmarksIfNotSaved,
        trackedLines: [],
        searchCardState: storage.getSavedSearchCardState() ?? searchCardStateIfNotSaved
      ),
      apiData: ApiData(
        lines: .none,
        vehicleLocations: .none
      )
    )
  }
}
