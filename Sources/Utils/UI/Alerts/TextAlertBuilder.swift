//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class TextAlertBuilder {

  // MARK: - Properties

  var title:   String
  var message: String?

  var closeButtonTitle = "Close"

  // MARK: - Init

  init(title: String) {
    self.title = title
  }

  // MARK: - Methods

  func create() -> UIAlertController {
    let alertController = UIAlertController(title: self.title, message: self.message, preferredStyle: .alert)
    alertController.view.setStyle(.alert)

    let closeAction = UIAlertAction(title: self.closeButtonTitle, style: .default, handler: nil)
    alertController.addAction(closeAction)

    return alertController
  }
}
