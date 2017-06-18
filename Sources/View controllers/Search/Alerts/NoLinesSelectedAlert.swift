//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class NoLinesSelectedAlert {

  static func create() -> UIAlertController {
    let alertController = UIAlertController(title: "No lines selected", message: "Please select some lines before trying to create bookmark.", preferredStyle: .alert)
    alertController.view.setStyle(.alert)

    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)

    return alertController
  }

}
