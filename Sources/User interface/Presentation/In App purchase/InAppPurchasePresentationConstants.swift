//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct InAppPurchasePresentationConstants {

  struct Layout {
    static let leftOffset:  CGFloat = 16.0
    static let rightOffset: CGFloat = leftOffset

    struct Page {
      struct Image {
        static let topOffset: CGFloat = 8.0
      }

      struct Title {
        static let topOffset: CGFloat = 8.0
      }

      struct Caption {
        static let topOffset:    CGFloat = 5.0
        static let bottomOffset: CGFloat = 0.0
        static let lineSpacing:  CGFloat = 2.0
      }
    }

    struct UpgradeButton {
      static let topOffset:    CGFloat      = 8.0
      static let cornerRadius: CGFloat      = 5.0
      static let edgeInsets:   UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
    }

    struct RestoreLabel {
      static let topOffset: CGFloat =  8.0
    }

    struct PageControl {
      static let topOffset:    CGFloat = -8.0
      static let bottomOffset: CGFloat = -4.0
    }
  }

  struct Colors {
    struct UpgradeButton {
      static let background = UIColor(red: 0.00, green: 0.59, blue: 0.95, alpha: 1.00)
    }

    struct Gradient {
      static let colors: [UIColor] = [
        UIColor(red: 0.18, green: 0.85, blue: 0.80, alpha: 1.00),
        UIColor(red: 0.13, green: 0.65, blue: 0.85, alpha: 1.00),
        UIColor(red: 0.40, green: 0.30, blue: 0.60, alpha: 1.00)
      ]

      static let locations: [NSNumber] = [0.0, 0.35, 0.9]
    }
  }
}
