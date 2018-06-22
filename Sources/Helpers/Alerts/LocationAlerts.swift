// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift

class LocationAlerts {

  /// Prompt for authorization change in settings
  static func showDeniedLocationAuthorizationAlert() -> Observable<Void> {
    typealias Localization = Localizable.Alert.Location.Denied
    return AlertCreator.createAlert(
      title:   Localization.title,
      message: Localization.message,
      buttons: [
        AlertButton(title: Localization.settings, style: .default, result: ()),
        AlertButton(title: Localization.ok,       style: .default, result: ())
      ]
    )
  }

  /// Notify that it is not possible to show user location
  static func showGloballyDeniedLocationAuthorizationAlert() -> Observable<Void> {
    typealias Localization = Localizable.Alert.Location.GloballyDenied
    return AlertCreator.createAlert(
      title:   Localization.title,
      message: Localization.message,
      buttons: [AlertButton(title: Localization.ok, style: .default, result: ())]
    )
  }
}
