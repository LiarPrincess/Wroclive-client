//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
  class var titleFont: UIFont? {
    get { return UINavigationBar.appearance().titleTextAttributes?[NSFontAttributeName] as? UIFont }
    set { UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: newValue as Any] }
  }
}
