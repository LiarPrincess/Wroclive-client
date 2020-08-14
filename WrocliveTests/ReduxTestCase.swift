// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import ReSwift
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

/// Test case that uses `ReSwift`.
protocol ReduxTestCase: AnyObject {
  var store: Store<AppState>! { get set }
  var dispatchedActions: [Action]! { get set }
}

private enum TestActions: Action {
  case setState((inout AppState) -> ())
}

extension ReduxTestCase {

  // MARK: - Set up

  func setUpRedux() {
    let state = AppState(
      userLocationAuthorization: .notDetermined,
      bookmarks: [],
      trackedLines: [],
      getLinesResponse: .none,
      getVehicleLocationsResponse: .none
    )

    self.setUpRedux(state: state)
  }

  func setUpRedux(state: AppState) {
    self.dispatchedActions = []

    let reducer = self.reducer
    let middleware = self.allowOnlyTestActions()
    self.store = Store<AppState>(reducer: reducer,
                                 state: state,
                                 middleware: [middleware])
  }

  private func reducer(action: Action, state: AppState?) -> AppState {
    if case let TestActions.setState(f) = action {
      var copy = state!
      f(&copy)
      return copy
    }

    fatalError("'allowOnltTestActions' middleware failed for: \(action)")
  }

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

  // MARK: - Set state

  func setState(_ change: @escaping (inout AppState) -> ()) {
    self.store.dispatch(TestActions.setState(change))
  }

  // MARK: - User location authorization actions

  func getSetUserLocationAuthorizationAction(at index: Int) -> UserLocationAuthorization? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let UserLocationAuthorizationAction.set(value): return value
    default: return nil
    }
  }

  func isRequestWhenInUseAuthorizationAction(at index: Int) -> Bool {
    guard index < self.dispatchedActions.count else { return false }
    switch self.dispatchedActions[index] {
    case UserLocationAuthorizationAction.requestWhenInUseAuthorization: return true
    default: return false
    }
  }

  // MARK: - Bookmark actions

  func getAddBookmarkAction(at index: Int) -> (name: String, lines: [Line])? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let BookmarksAction.add(name, lines): return (name, lines)
    default: return nil
    }
  }

  func getRemoveBookmarkAction(at index: Int) -> Int? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let BookmarksAction.remove(value): return value
    default: return nil
    }
  }

  func getMoveBookmarkAction(at index: Int) -> (from: Int, to: Int)? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let BookmarksAction.move(from, to): return (from, to)
    default: return nil
    }
  }

  // MARK: - Tracked lines actions

  func getStartTrackingLinesAction(at index: Int) -> [Line]? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let TrackedLinesAction.startTracking(lines): return lines
    default: return nil
    }
  }

  // MARK: - Api response

  func isRequestLinesAction(at index: Int) -> Bool {
    guard index < self.dispatchedActions.count else { return false }
    switch self.dispatchedActions[index] {
    case ApiMiddlewareActions.requestLines: return true
    default: return false
    }
  }

  func isRequestVehicleLocationsAction(at index: Int) -> Bool {
    guard index < self.dispatchedActions.count else { return false }
    switch self.dispatchedActions[index] {
    case ApiMiddlewareActions.requestVehicleLocations: return true
    default: return false
    }
  }
}
