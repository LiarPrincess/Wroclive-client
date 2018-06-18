//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

extension UISegmentedControl {
  var font: UIFont {
    // swiftlint:disable:next force_cast
    get { return self.titleTextAttributes(for: .normal)?[NSAttributedStringKey.font] as! UIFont }
    set { self.setTitleTextAttributes([NSAttributedStringKey.font: newValue as Any], for: .normal) }
  }
}
