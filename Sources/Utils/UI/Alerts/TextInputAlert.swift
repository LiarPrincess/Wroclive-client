//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

// source: https://stackoverflow.com/a/25628065

enum TextInputAlertResult {
  case confirm(text: String)
  case cancel
  case error
}

class TextInputAlert {

  //MARK: - Properties

  var title:   String?
  var message: String?

  var placeholder = ""

  var confirmButtonTitle = "Ok"
  var cancelButtonTitle  = "Cancel"

  //MARK: - Init

  init(title: String?, message: String?) {
    self.title   = title
    self.message = message
  }

  //MARK: - Methods

  typealias TextInputAlertCompletion = (TextInputAlertResult) -> ()

  func present(in viewController: UIViewController, animated: Bool, completion: TextInputAlertCompletion? = nil) {
    let alertController = UIAlertController(title: self.title, message: self.message, preferredStyle: .alert)
    alertController.view.setStyle(.alert)

    let cancelAction = UIAlertAction(title: self.cancelButtonTitle, style: .cancel) { _ in
      completion?(.cancel)
    }
    alertController.addAction(cancelAction)

    let confirmAction = UIAlertAction(title: self.confirmButtonTitle, style: .default) { [weak alertController] _ in
      if let textField = alertController?.textFields?[0], let text = textField.text {
        completion?(.confirm(text: text))
      }
      else {
        completion?(.error)
      }
    }
    confirmAction.isEnabled = false
    alertController.addAction(confirmAction)

    alertController.addTextField { textField in
      textField.placeholder            = self.placeholder
      textField.autocapitalizationType = .sentences
      textField.addTarget(TextInputAlert.self, action: #selector(TextInputAlert.textValueChanged(_:)), for: .editingChanged)
    }

    viewController.present(alertController, animated: animated, completion: nil)
  }

  @objc private static func textValueChanged(_ sender: UITextField) {
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
