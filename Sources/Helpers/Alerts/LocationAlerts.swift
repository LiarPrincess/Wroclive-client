//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias AuthorizationDenied         = Localizable.Alert.Location.Denied
private typealias AuthorizationGloballyDenied = Localizable.Alert.Location.GloballyDenied
private typealias InvalidCity = Localizable.Alert.InvalidCity

enum InvalidCityOptions {
  case showDefault
  case ignore
}

class LocationAlerts {

  // MARK: - AuthorizationDenied

  /// Prompt for authorization change in settings
  static func showDeniedLocationAuthorizationAlert(in parent: UIViewController) {
    let title   = AuthorizationDenied.title
    let message = AuthorizationDenied.content
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let settingsAction = UIAlertAction(title: AuthorizationDenied.settings, style: .default) { _ in
      if let url = URL(string: UIApplicationOpenSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
    alert.addAction(settingsAction)

    let okAction = UIAlertAction(title: AuthorizationDenied.ok, style: .default, handler: nil)
    alert.addAction(okAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - AuthorizationGloballyDenied

  /// Notify that it is not possible to show user location
  static func showGloballyDeniedLocationAuthorizationAlert(in parent: UIViewController) {
    let title   = AuthorizationGloballyDenied.title
    let message = AuthorizationGloballyDenied.content
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: AuthorizationGloballyDenied.ok, style: .default, handler: nil)
    alert.addAction(okAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - InvalidCity

  // Notify that current location is far from default city
  static func showInvalidCityAlert(in parent: UIViewController, completed: @escaping (InvalidCityOptions) -> ()) {
    let title   = InvalidCity.title
    let message = InvalidCity.message
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let noAction = UIAlertAction(title: InvalidCity.no, style: .cancel) { _ in completed(.ignore) }
    alert.addAction(noAction)

    let yesAction = UIAlertAction(title: InvalidCity.yes, style: .default) { _ in completed(.showDefault) }
    alert.addAction(yesAction)

    parent.present(alert, animated: true, completion: nil)
  }
}
