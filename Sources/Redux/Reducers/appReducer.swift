// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
  return AppState(
    userData: userDataReducer(action: action, state: state?.userData),
    apiData:  apiDataReducer(action: action, state: state?.apiData)
  )
}
