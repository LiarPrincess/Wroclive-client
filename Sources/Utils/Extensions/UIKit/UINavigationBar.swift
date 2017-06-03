//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

extension UINavigationBar {
  class var titleFont: UIFont? {
    get { return UINavigationBar.appearance().titleTextAttributes?[NSFontAttributeName] as? UIFont }
    set { UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: newValue as Any] }
  }
}
