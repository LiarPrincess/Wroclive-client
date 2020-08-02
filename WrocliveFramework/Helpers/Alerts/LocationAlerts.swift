// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import PromiseKit

public enum LocationAlerts {

  /// Prompt for authorization change in settings
  public static func showDeniedLocationAuthorizationAlert() -> Promise<Void> {
    typealias L = Localizable.Alert.Location.Denied
    return AlertCreator.create(
      title:   L.title,
      message: L.message,
      buttons: [
        AlertCreator.Button(title: L.settings, style: .default, result: ()),
        AlertCreator.Button(title: L.ok,       style: .default, result: ())
      ]
    )
  }

  /// Notify that it is not possible to show user location
  public static func showGloballyDeniedLocationAuthorizationAlert() -> Promise<Void> {
    typealias L = Localizable.Alert.Location.GloballyDenied
    return AlertCreator.create(
      title:   L.title,
      message: L.message,
      buttons: [
        AlertCreator.Button(title: L.ok, style: .default, result: ())
      ]
    )
  }
}
