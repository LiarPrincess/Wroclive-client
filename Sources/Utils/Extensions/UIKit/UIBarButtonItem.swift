//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
  class var font: UIFont? {
    get { return UIBarButtonItem.appearance().titleTextAttributes(for: .normal)?[NSFontAttributeName] as! UIFont? }
    set { UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: newValue as Any], for: .normal) }
  }
}
