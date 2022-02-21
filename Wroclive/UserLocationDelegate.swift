// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import os.log
import ReSwift
import WrocliveFramework

internal final class UserLocationDelegate: UserLocationManagerDelegate {

  private let store: Store<AppState>
  private let environment: Environment

  private var log: OSLog {
    return self.environment.log.app
  }

  internal init(store: Store<AppState>, environment: Environment) {
    self.store = store
    self.environment = environment
  }

  /// This will be called:
  /// - When the app is launched for the 1st time with '.notDetermined'
  /// - When the user selects status from prompt
  /// - When the user changes authorization in settings and launches app
  internal func locationManager(
    _ manager: UserLocationManagerType,
    didChangeAuthorization status: UserLocationAuthorization
  ) {
    os_log("locationManager(_:didChangeAuthorization:) to '%{public}@'",
           log: self.log,
           type: .info,
           String(describing: status))

    let action = UserLocationAuthorizationAction.set(status)
    self.store.dispatch(action)
  }
}
