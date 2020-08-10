// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

// When writing 'CustomStringConvertible' remember to avoid printing sensitive
// user data (for example location)!

// MARK: - User location authorization

public enum UserLocationAuthorizationAction: Action, CustomStringConvertible {
  case set(UserLocationAuthorization)
  case requestWhenInUseAuthorization

  public var description: String {
    switch self {
    case .set:
      return "UserLocationAuthorizationAction.set"
    case .requestWhenInUseAuthorization:
      return "UserLocationAuthorizationAction.requestWhenInUseAuthorization"
    }
  }
}

// MARK: - User data

public enum BookmarksAction: Action, CustomStringConvertible {
  case add(name: String, lines: [Line])
  case remove(at: Int)
  case move(from: Int, to: Int)

  public var description: String {
    switch self {
    case .add: return "BookmarksAction.add"
    case .remove: return "BookmarksAction.remove"
    case .move: return "BookmarksAction.move"
    }
  }
}

public enum TrackedLinesAction: Action, CustomStringConvertible {
  case startTracking([Line])

  public var description: String {
    switch self {
    case .startTracking: return "TrackedLinesAction.startTracking"
    }
  }
}

// MARK: - Api response

/// This type of api action is intended for ApiMiddleware
public enum ApiMiddlewareActions: Action, CustomStringConvertible {
  case requestLines
  case requestVehicleLocations

  public var description: String {
    switch self {
    case .requestLines: return "ApiMiddlewareActions.updateLines"
    case .requestVehicleLocations: return "ApiMiddlewareActions.updateVehicleLocations"
    }
  }
}

/// This type of api action is dispatched by ApiMiddleware
public enum ApiAction: Action, CustomStringConvertible {
  case setLines(AppState.ApiResponseState<[Line]>)
  case setVehicleLocations(AppState.ApiResponseState<[Vehicle]>)

  public var description: String {
    switch self {
    case let .setLines(response):
      return "ApiAction.setLines(\(describe(response)))"
    case let .setVehicleLocations(response):
      return "ApiAction.setVehicleLocations(\(describe(response)))"
    }
  }
}

private func describe<Data>(_ resonse: AppState.ApiResponseState<Data>) -> String {
  switch resonse {
  case .none:       return ".none"
  case .inProgress: return ".inProgress"
  case .data:       return ".data"
  case let .error(error): return ".error(\(String(describing: error)))"
  }
}
