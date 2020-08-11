// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import ReSwift
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

/// Test case that uses ReSwift
protocol ReduxTestCase: class {
  var store: Store<AppState>! { get set }
  var dispatchedActions: [Action]! { get set }
}

private enum TestAction: Action {
  case set((inout AppState) -> ())
}

extension ReduxTestCase {

  func setUpRedux() {
    let state = AppState(
      userData: UserDataState(bookmarks: [], searchCardState: .default, trackedLines: []),
      apiData: ApiDataState()
    )
    self.setUpRedux(state: state)
  }

  func setUpRedux(state: AppState) {
    self.dispatchedActions = []
    self.store = Store<AppState>(reducer: self.reducer, state: state)
  }

  func tearDownRedux() {
    self.store = nil
    self.dispatchedActions = nil
  }

  func setState(_ change: @escaping (inout AppState) -> ()) {
    self.store.dispatch(TestAction.set(change))
  }

  func reducer(action: Action, state: AppState?) -> AppState {
    if case let TestAction.set(f) = action {
      var copy = state!
      f(&copy)
      return copy
    }

    self.dispatchedActions.append(action)
    return state!
  }
}
