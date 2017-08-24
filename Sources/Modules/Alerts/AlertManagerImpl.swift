//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Localization = Localizable.Alerts
private typealias LocalizationLocationDenied         = Localization.Location.Denied
private typealias LocalizationLocationGloballyDenied = Localization.Location.DeniedGlobally
private typealias LocalizationBookmarksNoLines       = Localization.Bookmark.NoLinesSelected
private typealias LocalizationBookmarksNameInput     = Localization.Bookmark.NameInput
private typealias LocalizationBookmarksInstructions  = Localization.Bookmark.Instructions
private typealias LocalizationNetworkNoInternet      = Localization.Network.NoInternet
private typealias LocalizationNetworkConnectionError = Localization.Network.ConnectionError

class AlertManagerImpl: AlertManager {

  // MARK: - Map - Denied

  func showDeniedLocationAuthorizationAlert(in parent: UIViewController) {
    let title   = LocalizationLocationDenied.title
    let message = LocalizationLocationDenied.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let settingsAction = UIAlertAction(title: LocalizationLocationDenied.settings, style: .default) { _ in
      if let url = URL(string: UIApplicationOpenSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
    alert.addAction(settingsAction)

    let okAction = UIAlertAction(title: LocalizationLocationDenied.ok, style: .default, handler: nil)
    alert.addAction(okAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - Map - Globally denied

  func showGloballyDeniedLocationAuthorizationAlert(in parent: UIViewController) {
    let title   = LocalizationLocationGloballyDenied.title
    let message = LocalizationLocationGloballyDenied.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: LocalizationLocationGloballyDenied.ok, style: .default, handler: nil)
    alert.addAction(okAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - Bookmarks - No lines selected

  func showBookmarkNoLinesSelectedAlert(in parent: UIViewController) {
    let title   = LocalizationBookmarksNoLines.title
    let message = LocalizationBookmarksNoLines.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: LocalizationBookmarksNoLines.ok, style: .default, handler: nil)
    alert.addAction(okAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - Bookmarks - Name input

  func showBookmarkNameInputAlert(in parent: UIViewController, completed: @escaping (String?) -> ()) {
    let title   = LocalizationBookmarksNameInput.title
    let message = LocalizationBookmarksNameInput.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: LocalizationBookmarksNameInput.cancel, style: .cancel) { _ in completed(nil) }
    alert.addAction(cancelAction)

    let confirmAction = UIAlertAction(title: LocalizationBookmarksNameInput.save, style: .default) { [weak alert] _ in
      completed(alert?.textFields?.first?.text)
    }
    confirmAction.isEnabled = false
    alert.addAction(confirmAction)

    alert.addTextField { textField in
      textField.placeholder            = LocalizationBookmarksNameInput.placeholder
      textField.autocapitalizationType = .sentences
      textField.addTarget(AlertManagerImpl.self, action: #selector(AlertManagerImpl.enableConfirmIfTextNotEmpty(_:)), for: .editingChanged)
    }

    parent.present(alert, animated: true, completion: nil)
  }

  @objc private static func enableConfirmIfTextNotEmpty(_ sender: UITextField) {
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

  // MARK: - Bookmarks - Instructions

  func showBookmarkInstructionsAlert(in parent: UIViewController) {
    let title   = LocalizationBookmarksInstructions.title
    let message = LocalizationBookmarksInstructions.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let closeAction = UIAlertAction(title: LocalizationBookmarksInstructions.ok, style: .default, handler: nil)
    alert.addAction(closeAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - Network - No internet

  func showNoInternetAlert(in parent: UIViewController, retry: @escaping () -> ()) {
    let title   = LocalizationNetworkNoInternet.title
    let message = LocalizationNetworkNoInternet.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let againAction = UIAlertAction(title: LocalizationNetworkNoInternet.tryAgain, style: .cancel)  { _ in retry() }
    alert.addAction(againAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - Network - Networking

  func showNetworkingErrorAlert(in parent: UIViewController, retry: @escaping () -> ()) {
    let title   = LocalizationNetworkConnectionError.title
    let message = LocalizationNetworkConnectionError.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let againAction = UIAlertAction(title: LocalizationNetworkConnectionError.tryAgain, style: .cancel) { _ in retry() }
    alert.addAction(againAction)

    parent.present(alert, animated: true, completion: nil)
  }
}
