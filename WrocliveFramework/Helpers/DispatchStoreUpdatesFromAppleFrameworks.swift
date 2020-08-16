// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

/// Dispatch store update action when we recieve new data from Apple frameworks.
///
/// Currently only for user location authorization.
public final class DispatchStoreUpdatesFromAppleFrameworks: NSObject {

  private let store: Store<AppState>
  private let environment: Environment

  public init(store: Store<AppState>, environment: Environment) {
    self.store = store
    self.environment = environment
    super.init()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.didChangeUserlocationAuthorization(_:)),
      name: .didChangeUserlocationAuthorization,
      object: nil
    )
  }

  @objc
  private func didChangeUserlocationAuthorization(_ notification: Notification) {
    let authorization = self.environment.userLocation.getAuthorizationStatus()
    self.store.dispatch(UserLocationAuthorizationAction.set(authorization))
  }
}
