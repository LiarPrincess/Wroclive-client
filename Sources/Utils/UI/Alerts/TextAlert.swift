//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class TextAlert {

  // MARK: - Properties

  var title:   String?
  var message: String?

  var closeButtonTitle = "Close"

  // MARK: - Init

  init(title: String?, message: String?) {
    self.title   = title
    self.message = message
  }

  // MARK: - Methods

  func present(in viewController: UIViewController, animated: Bool) {
    let alertController = UIAlertController(title: self.title, message: self.message, preferredStyle: .alert)
    alertController.view.setStyle(.alert)

    let closeAction = UIAlertAction(title: self.closeButtonTitle, style: .default, handler: nil)
    alertController.addAction(closeAction)

    viewController.present(alertController, animated: animated, completion: nil)
  }
}
