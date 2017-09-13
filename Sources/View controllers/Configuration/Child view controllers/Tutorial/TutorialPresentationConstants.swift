//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct TutorialPresentationConstants {

  struct Layout {
    static let leftOffset:  CGFloat = 28.0
    static let rightOffset: CGFloat = leftOffset

    struct BackButton {
      static let imageSize = CGSize(width: 20.0, height: 20.0)
      static let insets    = UIEdgeInsets(top: 32.0, left: 8.0, bottom: 8.0, right: 8.0)
    }

    struct Page {
      static let topInset: CGFloat = 28.0

      struct Title {
        static let topOffset: CGFloat = 16.0
      }

      struct Caption {
        static let topOffset:   CGFloat = 12.0
        static let lineSpacing: CGFloat = 5.0
      }
    }

    struct PageControl {
      static let topOffset:    CGFloat =  8.0
      static let bottomOffset: CGFloat = -2.0
    }
  }
}
