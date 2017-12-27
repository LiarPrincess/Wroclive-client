//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct ConfigurationViewControllerConstants {
  struct Layout {
    static let leftInset:  CGFloat = 16.0
    static let rightInset: CGFloat = leftInset

    struct Header {
      static let topInset:    CGFloat = 28.0
      static let bottomInset: CGFloat =  8.0
    }

    struct Content {
      static let initialScrollPercent: CGFloat = 0.125
    }

    struct Footer {
      static let topOffset:    CGFloat =  5.0
      static let bottomOffset: CGFloat = 20.0
      static let lineSpacing:  CGFloat =  5.0
    }
  }

  struct CardPanel {
    static let relativeHeight: CGFloat = 0.75
  }
}
