//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class AlertManagerImpl: AlertManager {

  // MARK: - Location

  func showDeniedAuthorizationAlert(in parent: UIViewController) {
    let title   = "Location access is disabled"
    let message = "In order show your current location, please open settings and set location access to 'In use'."

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.view.setStyle(.alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(cancelAction)

    let openAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
      if let url = URL(string: UIApplicationOpenSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
    alert.addAction(openAction)

    parent.present(alert, animated: true, completion: nil)
  }

  func showRestrictedAuthorizationAlert(in parent: UIViewController) {
    let title   = "Location access is disabled"
    let message = "You can enable location access in your device settings."

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.view.setStyle(.alert)

    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    alert.addAction(okAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - Bookmarks

  func showNoLinesSelectedAlert(in parent: UIViewController) {
    let title   = "No lines selected"
    let message = "Please select some lines before trying to create bookmark."

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.view.setStyle(.alert)

    let closeAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(closeAction)

    parent.present(alert, animated: true, completion: nil)
  }

  func showBookmarkNameInputAlert(in parent: UIViewController, completed: @escaping (String?) -> ()) {
    let title   = "New bookmark"
    let message = "Enter name for this bookmark."

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.view.setStyle(.alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in completed(nil) }
    alert.addAction(cancelAction)

    let confirmAction = UIAlertAction(title: "Save", style: .default) { [weak alert] _ in
      completed(alert?.textFields?.first?.text)
    }
    confirmAction.isEnabled = false
    alert.addAction(confirmAction)

    alert.addTextField { textField in
      textField.placeholder            = "Name"
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

  func showBookmarkInstructionsAlert(in parent: UIViewController) {
    let title   = "Bookmark saved"
    let message = "To view saved bookmarks select star from map view."

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.view.setStyle(.alert)

    let closeAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(closeAction)

    parent.present(alert, animated: true, completion: nil)
  }

}
