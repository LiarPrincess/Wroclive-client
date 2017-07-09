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

class TextInputAlertBuilder {

  // MARK: - Properties

  var title:   String
  var message: String?

  var placeholder = ""

  var confirmButtonTitle = "Ok"
  var cancelButtonTitle  = "Cancel"

  typealias TextInputAlertCompletion = (TextInputAlertResult) -> ()
  var completion: TextInputAlertCompletion?

  // MARK: - Init

  init(title: String) {
    self.title = title
  }

  // MARK: - Methods

  func create() -> UIAlertController {
    let alertController = UIAlertController(title: self.title, message: self.message, preferredStyle: .alert)
    alertController.view.setStyle(.alert)

    let cancelAction = UIAlertAction(title: self.cancelButtonTitle, style: .cancel) { _ in
      self.completion?(.cancel)
    }
    alertController.addAction(cancelAction)

    let confirmAction = UIAlertAction(title: self.confirmButtonTitle, style: .default) { [weak alertController] _ in
      if let textField = alertController?.textFields?[0], let text = textField.text {
        self.completion?(.confirm(text: text))
      }
      else {
        self.completion?(.error)
      }
    }
    confirmAction.isEnabled = false
    alertController.addAction(confirmAction)

    alertController.addTextField { textField in
      textField.placeholder            = self.placeholder
      textField.autocapitalizationType = .sentences
      textField.addTarget(TextInputAlertBuilder.self, action: #selector(TextInputAlertBuilder.textValueChanged(_:)), for: .editingChanged)
    }

    return alertController
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
