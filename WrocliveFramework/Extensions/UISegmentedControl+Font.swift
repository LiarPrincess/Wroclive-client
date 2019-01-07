// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

extension UISegmentedControl {
  public var font: UIFont {
    get { return self.titleTextAttributes(for: .normal)?[NSAttributedString.Key.font] as! UIFont }
    set { self.setTitleTextAttributes([NSAttributedString.Key.font: newValue as Any], for: .normal) }
  }
}
