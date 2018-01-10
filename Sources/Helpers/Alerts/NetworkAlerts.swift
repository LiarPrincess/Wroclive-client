//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift

private typealias NoInternet      = Localizable.Alert.Network.NoInternet
private typealias ConnectionError = Localizable.Alert.Network.ConnectionError

class NetworkAlerts {

  // MARK: - NoInternet

  /// Prompt: check network settings. try again
  static func showNoInternetAlert(in parent: UIViewController, retry: @escaping () -> ()) {
    let title   = NoInternet.title
    let message = NoInternet.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let againAction = UIAlertAction(title: NoInternet.tryAgain, style: .cancel)  { _ in retry() }
    alert.addAction(againAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - ConnectionError

  /// Prompt: connection error alert. try again
  static func showNetworkingErrorAlert(in parent: UIViewController, retry: @escaping () -> ()) {
    let title   = ConnectionError.title
    let message = ConnectionError.content

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let againAction = UIAlertAction(title: ConnectionError.tryAgain, style: .default) { _ in retry() }
    alert.addAction(againAction)

    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - Observable

  static func showNoInternetAlert() -> Observable<Void> {
    typealias Loc = Localizable.Alert.Network.NoInternet
    return createSingleButtonAlert(title: Loc.title, message: Loc.content, button: Loc.tryAgain)
  }

  static func showErrorAlert() -> Observable<Void> {
    typealias Loc = Localizable.Alert.Network.ConnectionError
    return createSingleButtonAlert(title: Loc.title, message: Loc.content, button: Loc.tryAgain)
  }

  private static func createSingleButtonAlert(title: String, message: String, button: String) -> Observable<Void> {
    return .create { observer in
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: button, style: .default) { _ in
        observer.onNext()
        observer.onCompleted()
      })

      present(alert, animated: true)
      return Disposables.create { dismiss(alert, animated: false) }
    }
  }

  // MARK: - Present, Dismiss

  private static var topViewController: UIViewController? {
    var result = UIApplication.shared.keyWindow?.rootViewController
    var child  = result?.presentedViewController

    while child != nil {
      result = child
      child = result?.presentedViewController
    }

    return result
  }

  private static func present(_ alertController: UIAlertController, animated: Bool) {
    guard let viewController = topViewController else {
      Swift.print("Unable to show alert. Could not find top view controller.")
      return
    }

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
