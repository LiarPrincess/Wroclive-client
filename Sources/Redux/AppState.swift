// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import ReSwift

struct AppState: StateType {
  var userData: UserDataState
  var apiData:  ApiDataState
}

func loadState(from storage: StorageManagerType) -> AppState {
  return AppState(
    userData: UserDataState(
      bookmarks: storage.loadBookmarks(),
      searchCardState: storage.loadSearchCardState()
    ),
    apiData: ApiDataState()
  )
}

func createMiddlewares(_ environment: Environment) -> [Middleware<AppState>] {
  let logging = createLoggingMiddleware(bundle: environment.bundle)
  let api = createApiMiddleware(api: environment.api)
  let persistency = createPersistencyMiddleware(bundle: environment.bundle, storage: environment.storage)
  return [logging, api, persistency]
}

func mainReducer(action: Action, state: AppState?) -> AppState {
  return AppState(
    userData: userDataReducer(action: action, state: state?.userData),
    apiData:  apiDataReducer(action: action, state: state?.apiData)
  )
}
