//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit

extension UIApplication {
  static var topViewController: UIViewController {
    guard var result = UIApplication.shared.keyWindow?.rootViewController
      else { fatalError("Could not find top view controller.") }

    var child  = result.presentedViewController
    while child != nil {
      result = child!
      child = result.presentedViewController
    }

    return result
  }
}
