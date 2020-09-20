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

  public enum ShowAlertResult<Result> {
    case alert(Promise<Result>)
    case alreadyShowingDifferentAlert
  }

  public struct Button<Result> {
    let title: String
    let style: UIAlertAction.Style
    let result: Result
  }

  public static func show<Result>(title: String,
                                  message: String,
                                  buttons: [Button<Result>],
                                  animated: Bool = true) -> ShowAlertResult<Result> {
    switch Self.getTopViewController() {
    case .viewController(let parent):
      let promise = Promise<Result> { seal in
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        for button in buttons {
          alert.addAction(UIAlertAction(title: button.title, style: button.style) { _ in
            seal.fulfill(button.result)
          })
        }

        Self.present(alert: alert, parent: parent, animated: animated)
      }

      return .alert(promise)

    case .alreadyShowingDifferentAlert:
      return .alreadyShowingDifferentAlert
    }
  }

  // MARK: - Create text input

  public enum ShowTextInputAlertResult {
    case alert(Promise<String?>)
    case alreadyShowingDifferentAlert
  }

  public struct TextInputButton {
    let title: String
    let style: UIAlertAction.Style
  }

  public static func showTextInput(title: String,
                                   message: String,
                                   placeholder: String,
                                   confirm: TextInputButton,
                                   cancel: TextInputButton,
                                   animated: Bool = true) -> ShowTextInputAlertResult {
    switch Self.getTopViewController() {
    case .viewController(let parent):
      let promise = Promise<String?> { seal in
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

        present(alert: alert, parent: parent, animated: animated)
      }

      return .alert(promise)

    case .alreadyShowingDifferentAlert:
      return .alreadyShowingDifferentAlert
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

  // MARK: - Present, dismiss

  private enum TopViewController {
    case viewController(UIViewController)
    case alreadyShowingDifferentAlert
  }

  private static func getTopViewController() -> TopViewController {
    let viewController = UIApplication.topViewController

    if viewController is UIAlertController {
      return .alreadyShowingDifferentAlert
    }

    return .viewController(viewController)
  }

  private static func present(alert: UIAlertController,
                              parent: UIViewController,
                              animated: Bool) {
    parent.present(alert, animated: animated, completion: nil)
  }

  private static func dismiss(alert: UIAlertController, animated: Bool) {
    alert.dismiss(animated: animated, completion: nil)
  }

  // MARK: - Network

  /// Check network settings and try again
  public static func showReachabilityAlert() -> ShowAlertResult<Void> {
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
  public static func showConnectionErrorAlert() -> ShowAlertResult<Void> {
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

  public enum DeniedLocationAuthorizationAlertResult {
    /// Do nothing
    case ok
    case openSettings
  }

  /// Prompt for authorization change in settings
  public static func showDeniedLocationAuthorizationAlert() ->
    ShowAlertResult<DeniedLocationAuthorizationAlertResult> {

    typealias L = Localizable.Alert.Location.Denied
    return AlertCreator.show(
      title: L.title,
      message: L.message,
      buttons: [
        AlertCreator.Button(title: L.settings, style: .default, result: .openSettings),
        AlertCreator.Button(title: L.ok, style: .default, result: .ok)
      ]
    )
  }

  /// Notify that it is not possible to show user location
  public static func showGloballyDeniedLocationAuthorizationAlert() -> ShowAlertResult<Void> {
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
