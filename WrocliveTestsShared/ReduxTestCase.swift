// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import ReSwift
@testable import WrocliveFramework

// swiftlint:disable implicit_return
// swiftlint:disable implicitly_unwrapped_optional

/// Test case that uses `ReSwift`.
public protocol ReduxTestCase: AnyObject {
  var store: Store<AppState>! { get set }
  var dispatchedActions: [Action]! { get set }
}

private enum TestActions: Action {
  case setState((inout AppState) -> Void)
}

extension ReduxTestCase {

  // MARK: - Set up

  public func setUpRedux() {
    let state = AppState(
      mapType: .default,
      userLocationAuthorization: .notDetermined,
      bookmarks: [],
      trackedLines: [],
      getLinesResponse: .none,
      getNotificationsResponse: .none,
      getVehicleLocationsResponse: .none
    )

    self.setUpRedux(state: state)
  }

  public func setUpRedux(state: AppState) {
    self.dispatchedActions = []

    let reducer = self.reducer
    let middleware = self.allowOnlyTestActions()
    self.store = Store<AppState>(reducer: reducer,
                                 state: state,
                                 middleware: [middleware])
  }

  private func reducer(action: Action, state: AppState?) -> AppState {
    if case let TestActions.setState(f) = action {
      var copy = state! // swiftlint:disable:this force_unwrapping
      f(&copy)
      return copy
    }

    fatalError("'allowOnltTestActions' middleware failed for: \(action)")
  }

  // swiftformat:disable unusedArguments
  private func allowOnlyTestActions() -> Middleware<AppState> {
    return { [weak self] dispatch, getState in
      return { next in
        return { action in
          if action is TestActions {
            next(action)
          } else {
            self?.dispatchedActions.append(action)
          }
        }
      }
    }
  }

  // swiftformat:enable unusedArguments

  // MARK: - Set state

  public func setState(_ change: @escaping (inout AppState) -> Void) {
    self.store.dispatch(TestActions.setState(change))
  }

  // MARK: - User location authorization actions

  public func getSetUserLocationAuthorizationAction(at index: Int) -> UserLocationAuthorization? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let UserLocationAuthorizationAction.set(value): return value
    default: return nil
    }
  }

  // MARK: - Bookmark actions

  public func getAddBookmarkAction(at index: Int) -> (name: String, lines: [Line])? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let BookmarksAction.add(name, lines): return (name, lines)
    default: return nil
    }
  }

  public func getRemoveBookmarkAction(at index: Int) -> Int? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let BookmarksAction.remove(value): return value
    default: return nil
    }
  }

  public func getMoveBookmarkAction(at index: Int) -> (from: Int, to: Int)? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let BookmarksAction.move(from, to): return (from, to)
    default: return nil
    }
  }

  // MARK: - Tracked lines actions

  // swiftlint:disable:next discouraged_optional_collection
  public func getStartTrackingLinesAction(at index: Int) -> [Line]? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let TrackedLinesAction.startTracking(lines): return lines
    default: return nil
    }
  }

  // MARK: - Api response

  public func isRequestLinesAction(at index: Int) -> Bool {
    guard index < self.dispatchedActions.count else { return false }
    switch self.dispatchedActions[index] {
    case ApiMiddlewareActions.requestLines: return true
    default: return false
    }
  }

  public func isRequestNotificationsAction(at index: Int) -> Bool {
    guard index < self.dispatchedActions.count else { return false }
    switch self.dispatchedActions[index] {
    case ApiMiddlewareActions.requestNotifications: return true
    default: return false
    }
  }

  public func isRequestVehicleLocationsAction(at index: Int) -> Bool {
    guard index < self.dispatchedActions.count else { return false }
    switch self.dispatchedActions[index] {
    case ApiMiddlewareActions.requestVehicleLocations: return true
    default: return false
    }
  }
}
