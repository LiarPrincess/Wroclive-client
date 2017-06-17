//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct SearchViewControllerConstants {

  struct Layout {
    static let leftOffset:   CGFloat = 16.0
    static let rightOffset:  CGFloat = leftOffset
    static let bottomOffset: CGFloat = 28.0

    struct Header {
      static let chevronTopOffset:  CGFloat = 8.0

      static let topPadding:        CGFloat = 32.0
      static let bottomPadding:     CGFloat = 16.0

      static let verticalSpacing:   CGFloat = 8.0

      static let bookmarkButtonInsets = UIEdgeInsets(top: 10.0, left: 6.0,  bottom: 8.0, right: 16.0)
      static let searchButtonInsets   = UIEdgeInsets(top: 17.0, left: 16.0, bottom: 4.0, right: Layout.rightOffset)
    }
  }

  struct Animations {
    static let chevronDismisRelativeDuration: TimeInterval = 0.05
  }

}
