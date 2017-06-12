//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct BookmarksViewControllerConstants {

  struct Layout {
    static let leftOffset:  CGFloat = 16.0
    static let rightOffset: CGFloat = leftOffset

    struct Header {
      static let topPadding:        CGFloat = 32.0
      static let bottomPadding:     CGFloat =  8.0
      static let horizontalSpacing: CGFloat =  8.0
    }

    struct Cell {
      static let topPadding:    CGFloat = 10.0
      static let bottomPadding: CGFloat = topPadding

      static let leftOffset:  CGFloat = 45.0
      static let rightOffset: CGFloat = leftOffset

      static let verticalSpacing: CGFloat = 10.0

      static let estimatedHeight: CGFloat = 200.0

      struct LinesLabel {
        static let lineSpacing:  CGFloat = 3.0
      }
    }

    struct Placeholder {
      static let leftOffset:  CGFloat = 35.0
      static let rightOffset: CGFloat = leftOffset

      struct TopLabel {
        static let topOffset: CGFloat = 35.0
      }

      struct BottomLabel {
        static let topOffset: CGFloat = 15.0
      }
    }
  }

}
