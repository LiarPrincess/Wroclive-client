// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

public struct AppState: StateType {

  public var userLocationAuthorization: UserLocationAuthorization

  public var bookmarks: [Bookmark]
  public var trackedLines: [Line]

  public var getLinesResponse: ApiResponseState<[Line]>
  public var getVehicleLocationsResponse: ApiResponseState<[Vehicle]>

  public enum ApiResponseState<Data> {
    /// No response recieved (yet).
    /// Default state, just after starting the app.
    case none
    /// Request was send, no response (yet).
    case inProgress
    case data(Data)
    case error(ApiError)

    public var isNone: Bool {
      switch self {
      case .none: return true
      case .inProgress, .data, .error: return false
      }
    }

    public var isInProgress: Bool {
      switch self {
      case .inProgress: return true
      case .none, .data, .error: return false
      }
    }

    public func getData() -> Data? {
      switch self {
      case .data(let d): return d
      case .none, .inProgress, .error: return nil
      }
    }

    public func getError() -> ApiError? {
      switch self {
      case .error(let e): return e
      case .none, .inProgress, .data: return nil
      }
    }
  }

  public static func load(
    from environment: Environment,
    trackedLinesIfNotSaved: [Line],
    bookmarksIfNotSaved: [Bookmark]
  ) -> AppState {
    let storage = environment.storage
    let userLocation = environment.userLocation

    return AppState(
      userLocationAuthorization: userLocation.getAuthorizationStatus(),
      bookmarks: storage.readBookmarks() ?? bookmarksIfNotSaved,
      trackedLines: storage.readTrackedLines() ?? trackedLinesIfNotSaved,
      getLinesResponse: .none,
      getVehicleLocationsResponse: .none
    )
  }
}
