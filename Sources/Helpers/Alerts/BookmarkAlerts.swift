//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias NoLinesSelected = Localizable.Alert.Bookmark.NoLinesSelected
private typealias NameInput       = Localizable.Alert.Bookmark.NameInput

class BookmarkAlerts {

  // MARK: - NoLinesSelected

  /// Notify: bookmark cannot be created as no line was selected
  static func showBookmarkNoLinesSelectedAlert(in parent: UIViewController) {
    let title   = NoLinesSelected.title
    let message = NoLinesSelected.content
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: NoLinesSelected.ok, style: .default, handler: nil)
    alert.addAction(okAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - NameInput

  /// Prompt: bookmark name
  static func showBookmarkNameInputAlert(in parent: UIViewController, completed: @escaping (String?) -> ()) {
    let title   = NameInput.title
    let message = NameInput.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: NameInput.cancel, style: .cancel) { _ in completed(nil) }
    alert.addAction(cancelAction)

    let confirmAction = UIAlertAction(title: NameInput.save, style: .default) { [weak alert] _ in
      completed(alert?.textFields?.first?.text)
    }
    confirmAction.isEnabled = false
    alert.addAction(confirmAction)

    alert.addTextField { textField in
      textField.placeholder            = NameInput.placeholder
      textField.autocapitalizationType = .sentences
      textField.addTarget(BookmarkAlerts.self, action: #selector(BookmarkAlerts.enableConfirmIfTextNotEmpty(_:)), for: .editingChanged)
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
}
