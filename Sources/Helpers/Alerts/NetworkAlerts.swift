//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

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

  /// Cehck connection error alert. try again
  static func showConnectionErrorAlert() -> Observable<Void> {
    typealias Localization = Localizable.Alert.Network.ConnectionError
    return AlertCreator.createAlert(
      title:   Localization.title,
      message: Localization.message,
      buttons: [AlertButton(title: Localization.tryAgain, style: .default, result: ())]
    )
  }

  // MARK: - NoInternet

  private typealias NoInternet      = Localizable.Alert.Network.NoInternet
  private typealias ConnectionError = Localizable.Alert.Network.ConnectionError

  /// Prompt: check network settings. try again
  static func showNoInternetAlert(in parent: UIViewController, retry: @escaping () -> ()) {
    let title   = NoInternet.title
    let message = NoInternet.message

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let againAction = UIAlertAction(title: NoInternet.tryAgain, style: .cancel)  { _ in retry() }
    alert.addAction(againAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - ConnectionError

  /// Prompt: connection error alert. try again
  static func showNetworkingErrorAlert(in parent: UIViewController, retry: @escaping () -> ()) {
    let title   = ConnectionError.title
    let message = ConnectionError.message

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let againAction = UIAlertAction(title: ConnectionError.tryAgain, style: .default) { _ in retry() }
    alert.addAction(againAction)

    parent.present(alert, animated: true, completion: nil)
  }
}
