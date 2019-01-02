// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift

struct AlertButton<Value> {
  let title:  String
  let style:  UIAlertActionStyle
  let result: Value
}

class AlertCreator {

  static func createAlert<Result>(title:     String,
                                  message:   String,
                                  buttons:   [AlertButton<Result>],
                                  animated:  Bool = true) -> Observable<Result> {
    return .create { observer in
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

      for button in buttons {
        alert.addAction(UIAlertAction(title: button.title, style: button.style) { _ in
          observer.onNext(button.result)
          observer.onCompleted()
        })
      }

      present(alert, animated: animated)
      return Disposables.create { dismiss(alert, animated: animated) }
    }
  }

  static func createTextInputAlert(title:       String,
                                   message:     String,
                                   placeholder: String,
                                   confirm:     AlertButton<Void>,
                                   cancel:      AlertButton<Void>,
                                   animated:    Bool = true) -> Observable<String?> {
    return .create { observer in
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

      alert.addTextField { textField in
        textField.placeholder            = placeholder
        textField.autocapitalizationType = .sentences
        textField.addTarget(AlertCreator.self, action: #selector(AlertCreator.enableConfirmIfTextNotEmpty(_:)), for: .editingChanged)
      }

      alert.addAction(UIAlertAction(title: cancel.title, style: cancel.style) { _ in
        observer.onNext(nil)
        observer.onCompleted()
      })

      let confirmAction = UIAlertAction(title: confirm.title, style: confirm.style) { [weak alert] _ in
        observer.onNext(alert?.textFields?.first?.text)
        observer.onCompleted()
      }
      confirmAction.isEnabled = false
      alert.addAction(confirmAction)

      present(alert, animated: animated)
      return Disposables.create { dismiss(alert, animated: animated) }
    }
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
