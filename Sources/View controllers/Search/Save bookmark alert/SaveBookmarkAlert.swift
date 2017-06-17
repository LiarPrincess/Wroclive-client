//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class SaveBookmarkAlert {

  // source: https://stackoverflow.com/a/25628065

  static func create(forSaving lines: [Line]) -> UIAlertController {
    let alertController = UIAlertController(title: "New bookmark", message: "Enter name for this bookmark.", preferredStyle: .alert)
    alertController.view.setStyle(.alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)

    let saveAction = UIAlertAction(title: "Save", style: .default) { [weak alertController] _ in
      guard let nameTextField = alertController?.textFields?[0] else {
        return
      }

      let name     = nameTextField.text ?? ""
      let bookmark = Bookmark(name: name, lines: lines)
      BookmarksManager.instance.add(bookmark: bookmark)
    }
    saveAction.isEnabled = false
    alertController.addAction(saveAction)

    alertController.addTextField { textField in
      textField.placeholder            = "Name"
      textField.autocapitalizationType = .sentences
      textField.addTarget(self, action: #selector(self.bookmarkNameChanged(_:)), for: .editingChanged)
    }

    return alertController
  }

  @objc private static func bookmarkNameChanged(_ sender: UITextField) {
    let isNameEmpty = sender.text?.isEmpty ?? false

    if let alert = alertController(sender) {
      let saveAction = alert.actions[1] //fml
      saveAction.isEnabled = !isNameEmpty
    }
  }

  private static func alertController(_ sender: UITextField) -> UIAlertController? {
    var responder: UIResponder! = sender
    while responder != nil && !(responder is UIAlertController) {
      responder = responder.next
    }
    return responder as? UIAlertController
  }

}
