// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

extension UIApplication {
  public static var topViewController: UIViewController {
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
