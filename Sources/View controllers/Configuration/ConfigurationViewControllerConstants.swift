//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct ConfigurationViewControllerConstants {

  struct Layout {
    static let leftInset:  CGFloat = 16.0
    static let rightInset: CGFloat = leftInset

    struct NavigationBar {
      static let closeImageSize = CGSize(width: 15.0, height: 15.0)
    }

    struct Content {
      static let scrollHiddenPercent: CGFloat = 0.15
    }

    struct Footer {
      static let topOffset:    CGFloat =  5.0
      static let bottomOffset: CGFloat = 20.0
      static let lineSpacing:  CGFloat =  5.0
    }
  }
}
