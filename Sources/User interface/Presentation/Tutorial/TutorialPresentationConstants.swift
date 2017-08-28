//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct TutorialPresentationConstants {

  struct Layout {
    static let leftOffset:  CGFloat = 28.0
    static let rightOffset: CGFloat = leftOffset

    struct Page {
      struct Image {
        static let topOffset: CGFloat = 28.0
      }

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
