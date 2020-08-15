// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import PromiseKit

// swiftlint:disable nesting
// swiftlint:disable type_name

// This has to be class because we will be using '@objc'.
public final class AlertCreator {

  private init() {}

  // MARK: - Create

  public struct Button<Value> {
    let title: String
    let style: UIAlertAction.Style
    let result: Value
  }

  public static func show<Result>(title: String,
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

  // MARK: - Create text input

  public struct TextInputButton {
    let title: String
    let style: UIAlertAction.Style
  }

  public static func showTextInput(title: String,
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
    var responder: UIResponder? = sender
    while responder != nil && !(responder is UIAlertController) {
      responder = responder?.next
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

  // MARK: - Network

  /// Check network settings and try again
  public static func showReachabilityAlert() -> Promise<Void> {
    typealias L = Localizable.Alert.Network.NoInternet
    return AlertCreator.show(
      title: L.title,
      message: L.message,
      buttons: [
        AlertCreator.Button(title: L.tryAgain, style: .default, result: ())
      ]
    )
  }

  /// 'Check connection' alert and try again
  public static func showConnectionErrorAlert() -> Promise<Void> {
    typealias L = Localizable.Alert.Network.ConnectionError
    return AlertCreator.show(
      title: L.title,
      message: L.message,
      buttons: [
        AlertCreator.Button(title: L.tryAgain, style: .default, result: ())
      ]
    )
  }

  // MARK: - User location authorization

  /// Prompt for authorization change in settings
  public static func showDeniedLocationAuthorizationAlert() -> Promise<Void> {
    typealias L = Localizable.Alert.Location.Denied
    return AlertCreator.show(
      title: L.title,
      message: L.message,
      buttons: [
        AlertCreator.Button(title: L.settings, style: .default, result: ()),
        AlertCreator.Button(title: L.ok, style: .default, result: ())
      ]
    )
  }

  /// Notify that it is not possible to show user location
  public static func showGloballyDeniedLocationAuthorizationAlert() -> Promise<Void> {
    typealias L = Localizable.Alert.Location.GloballyDenied
    return AlertCreator.show(
      title: L.title,
      message: L.message,
      buttons: [
        AlertCreator.Button(title: L.ok, style: .default, result: ())
      ]
    )
  }
}
