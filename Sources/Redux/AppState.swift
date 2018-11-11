// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import ReSwift

struct AppState: StateType {
  var userData: UserDataState
}

func mainReducer(action: Action, state: AppState?) -> AppState {
  print(String(describing: type(of: action)) + "." + String(describing: action))

  return AppState(
    userData: userDataReducer(action: action, state: state?.userData)
  )
}

enum FutureActions: Action {
  case startTracking([Line])
}
