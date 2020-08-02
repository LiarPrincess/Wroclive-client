// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import PromiseKit

// This has to be class because we will be using '@objc'.
public final class AlertCreator {

  public struct Button<Value> {
    let title:  String
    let style:  UIAlertAction.Style
    let result: Value
  }

  public static func create<Result>(title: String,
                                    message: String,
                                    buttons: [Button<Result>],
                                    animated: Bool = true) -> Promise<Result> {
    return Promise<Result> { seal in
      let alert = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)

      for button in buttons {
        alert.addAction(UIAlertAction(title: button.title, style: button.style) { _ in
          seal.fulfill(button.result)
        })
      }

      Self.present(alert, animated: animated)
      // TODO: return Disposables.create { dismiss(alert, animated: animated) }
    }
  }

  public struct TextInputButton {
    let title: String
    let style: UIAlertAction.Style
  }

  public static func createWithTextInput(title: String,
                                         message: String,
                                         placeholder: String,
                                         confirm: TextInputButton,
                                         cancel: TextInputButton,
                                         animated: Bool = true) -> Promise<String?> {
    return Promise<String?> { seal in
      let alert = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)

      alert.addTextField { textField in
        textField.placeholder = placeholder
        textField.autocapitalizationType = .sentences
        textField.addTarget(
          AlertCreator.self,
          action: #selector(AlertCreator.enableConfirmIfTextNotEmpty(_:)),
          for: .editingChanged
        )
      }

      alert.addAction(UIAlertAction(title: cancel.title,
                                    style: cancel.style) { _ in
        seal.fulfill(nil)
      })

      // This has to be weak reference, otherwise we would create cycle
      let confirmAction = UIAlertAction(title: confirm.title,
                                        style: confirm.style) { [weak alert] _ in
        let text = alert?.textFields?.first?.text
        seal.fulfill(text)
      }
      confirmAction.isEnabled = false
      alert.addAction(confirmAction)

      present(alert, animated: animated)
      // TODO: return Disposables.create { dismiss(alert, animated: animated) }
    }
  }

  @objc
  private static func enableConfirmIfTextNotEmpty(_ sender: UITextField) {
    let isTextEmpty = sender.text?.isEmpty ?? false

    if let alertController = Self.parentAlertController(of: sender) {
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

  // MARK: - Present, Dismiss

  private static func present(_ alertController: UIAlertController, animated: Bool) {
    let viewController = UIApplication.topViewController

    if viewController is UIAlertController {
      Swift.print("Unable to show alert. Another alert is already presenting.")
      return
    }

    viewController.present(alertController, animated: animated, completion: nil)
  }

  private static func dismiss(_ alertController: UIAlertController, animated: Bool) {
    alertController.dismiss(animated: animated, completion: nil)
  }
}
