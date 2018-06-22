// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift

class NetworkAlerts {

  /// Check network settings and try again
  static func showNoInternetAlert() -> Observable<Void> {
    typealias Localization = Localizable.Alert.Network.NoInternet
    return AlertCreator.createAlert(
      title:   Localization.title,
      message: Localization.message,
      buttons: [AlertButton(title: Localization.tryAgain, style: .default, result: ())]
    )
  }

  /// 'Check connection' alert and try again
  static func showConnectionErrorAlert() -> Observable<Void> {
    typealias Localization = Localizable.Alert.Network.ConnectionError
    return AlertCreator.createAlert(
      title:   Localization.title,
      message: Localization.message,
      buttons: [AlertButton(title: Localization.tryAgain, style: .default, result: ())]
    )
  }
}
