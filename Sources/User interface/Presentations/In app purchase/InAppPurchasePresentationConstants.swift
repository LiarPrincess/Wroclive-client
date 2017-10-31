//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct InAppPurchasePresentationConstants {

  struct Layout {
    static let leftOffset:  CGFloat = 20.0
    static let rightOffset: CGFloat = leftOffset

    struct Page {
      static let leftOffset:  CGFloat = Layout.leftOffset
      static let rightOffset: CGFloat = Layout.rightOffset

      struct Title {
        static let topOffset: CGFloat = 12.0
      }

      struct Caption {
        static let topOffset:   CGFloat = 5.0
        static let lineSpacing: CGFloat = 5.0
      }
    }

    struct UpgradeButton {
      static let topOffset:    CGFloat      = 10.0
      static let cornerRadius: CGFloat      =  5.0
      static let edgeInsets:   UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
    }

    struct RestoreLabel {
      static let topOffset: CGFloat = 8.0
    }

    struct PageControl {
      static let topOffset:    CGFloat = -6.0
      static let bottomOffset: CGFloat = -2.0
    }
  }

  struct Timer {
    static let colorsChangeInterval: TimeInterval = 2.0
  }
}
