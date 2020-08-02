// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import PromiseKit

public enum NetworkAlerts {

  // TODO: Rename to 'Reachability'
  /// Check network settings and try again
  public static func showNoInternetAlert() -> Promise<Void> {
    typealias L = Localizable.Alert.Network.NoInternet
    return AlertCreator.create(
      title:   L.title,
      message: L.message,
      buttons: [
        AlertCreator.Button(title: L.tryAgain, style: .default, result: ())
      ]
    )
  }

  /// 'Check connection' alert and try again
  public static func showConnectionErrorAlert() -> Promise<Void> {
    typealias L = Localizable.Alert.Network.ConnectionError
    return AlertCreator.create(
      title:   L.title,
      message: L.message,
      buttons: [
        AlertCreator.Button(title: L.tryAgain, style: .default, result: ())
      ]
    )
  }
}
