//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import UIKit

extension UISegmentedControl {
  var font: UIFont? {
    get { return self.titleTextAttributes(for: .normal)?[NSFontAttributeName] as! UIFont? }
    set { self.setTitleTextAttributes([NSFontAttributeName: newValue as Any], for: .normal) }
  }
}
