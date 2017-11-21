//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Localization = Localizable.Alert
private typealias LocationDenied         = Localization.Location.Denied
private typealias LocationGloballyDenied = Localization.Location.GloballyDenied
private typealias LocationInvalidCity    = Localization.InvalidCity
private typealias BookmarksNoLines       = Localization.Bookmark.NoLinesSelected
private typealias BookmarksNameInput     = Localization.Bookmark.NameInput
private typealias NetworkNoInternet      = Localization.Network.NoInternet
private typealias NetworkConnectionError = Localization.Network.ConnectionError

class AlertManagerImpl: AlertManager {

  // MARK: - Map - Denied

  func showDeniedLocationAuthorizationAlert(in parent: UIViewController) {
    let title   = LocationDenied.title
    let message = LocationDenied.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let settingsAction = UIAlertAction(title: LocationDenied.settings, style: .default) { _ in
      if let url = URL(string: UIApplicationOpenSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
    alert.addAction(settingsAction)

    let okAction = UIAlertAction(title: LocationDenied.ok, style: .default, handler: nil)
    alert.addAction(okAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - Map - Globally denied

  func showGloballyDeniedLocationAuthorizationAlert(in parent: UIViewController) {
    let title   = LocationGloballyDenied.title
    let message = LocationGloballyDenied.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: LocationGloballyDenied.ok, style: .default, handler: nil)
    alert.addAction(okAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - Map - Invalid city

  func showInvalidCityAlert(in parent: UIViewController, completed: @escaping (InvalidCityOptions) -> ()) {
    let title   = LocationInvalidCity.title
    let message = LocationInvalidCity.message

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let noAction = UIAlertAction(title: LocationInvalidCity.no, style: .cancel) { _ in completed(.ignore) }
    alert.addAction(noAction)

    let yesAction = UIAlertAction(title: LocationInvalidCity.yes, style: .default) { _ in completed(.showDefault) }
    alert.addAction(yesAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - Bookmarks - No lines selected

  func showBookmarkNoLinesSelectedAlert(in parent: UIViewController) {
    let title   = BookmarksNoLines.title
    let message = BookmarksNoLines.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: BookmarksNoLines.ok, style: .default, handler: nil)
    alert.addAction(okAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - Bookmarks - Name input

  func showBookmarkNameInputAlert(in parent: UIViewController, completed: @escaping (String?) -> ()) {
    let title   = BookmarksNameInput.title
    let message = BookmarksNameInput.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: BookmarksNameInput.cancel, style: .cancel) { _ in completed(nil) }
    alert.addAction(cancelAction)

    let confirmAction = UIAlertAction(title: BookmarksNameInput.save, style: .default) { [weak alert] _ in
      completed(alert?.textFields?.first?.text)
    }
    confirmAction.isEnabled = false
    alert.addAction(confirmAction)

    alert.addTextField { textField in
      textField.placeholder            = BookmarksNameInput.placeholder
      textField.autocapitalizationType = .sentences
      textField.addTarget(AlertManagerImpl.self, action: #selector(AlertManagerImpl.enableConfirmIfTextNotEmpty(_:)), for: .editingChanged)
    }

    parent.present(alert, animated: true, completion: nil)
  }

  @objc
  private static func enableConfirmIfTextNotEmpty(_ sender: UITextField) {
    let isTextEmpty = sender.text?.isEmpty ?? false

    if let alertController = parentAlertController(of: sender) {
      let confirmAction = alertController.actions[1] // fml
      confirmAction.isEnabled = !isTextEmpty
    }
  }

  private static func parentAlertController(of sender: UITextField) -> UIAlertController? {
    var responder: UIResponder! = sender
    while responder != nil && !(responder is UIAlertController) {
      responder = responder.next
    }
    return responder as? UIAlertController
  }

  // MARK: - Network - No internet

  func showNoInternetAlert(in parent: UIViewController, retry: @escaping () -> ()) {
    let title   = NetworkNoInternet.title
    let message = NetworkNoInternet.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let againAction = UIAlertAction(title: NetworkNoInternet.tryAgain, style: .cancel)  { _ in retry() }
    alert.addAction(againAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - Network - Networking

  func showNetworkingErrorAlert(in parent: UIViewController, retry: @escaping () -> ()) {
    let title   = NetworkConnectionError.title
    let message = NetworkConnectionError.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let againAction = UIAlertAction(title: NetworkConnectionError.tryAgain, style: .cancel) { _ in retry() }
    alert.addAction(againAction)

    parent.present(alert, animated: true, completion: nil)
  }
}
