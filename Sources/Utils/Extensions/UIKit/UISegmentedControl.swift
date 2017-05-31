//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit

extension UISegmentedControl {
  var font: UIFont? {
    get { return self.titleTextAttributes(for: .normal)?[NSFontAttributeName] as! UIFont? }
    set { self.setTitleTextAttributes([NSFontAttributeName: newValue as Any], for: .normal) }
  }
}
