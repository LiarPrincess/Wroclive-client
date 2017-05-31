//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
  class var font: UIFont? {
    get { return UIBarButtonItem.appearance().titleTextAttributes(for: .normal)?[NSFontAttributeName] as! UIFont? }
    set { UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: newValue as Any], for: .normal) }
  }
}
