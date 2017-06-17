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
      static let chevronTopOffset:  CGFloat =  8.0

      static let topPadding:        CGFloat = 32.0
      static let bottomPadding:     CGFloat = 16.0

      static let verticalSpacing:   CGFloat =  8.0
      static let horizontalSpacing: CGFloat =  8.0
    }
  }

  struct Animations {
    static let chevronDismisRelativeDuration: TimeInterval = 0.05
  }

}
