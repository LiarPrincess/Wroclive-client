//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct BookmarksViewControllerConstants {

  struct Layout {

    struct Cell {
      static let topOffset:    CGFloat = 8.0
      static let bottomOffset: CGFloat = 6.0

      static let leftOffset:   CGFloat = 40.0
      static let rightOffset:  CGFloat = leftOffset

      static let estimatedHeight: CGFloat = 200.0

      struct LineCell {
        static let width:     CGFloat = 45.0
        static let height:    CGFloat = 30.0
        static let minMargin: CGFloat =  1.0
      }

      struct LineSection {
        static let insets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 5.0, right: 0.0)
      }
    }

    struct Placeholder {
      static let leftOffset:  CGFloat = 30.0
      static let rightOffset: CGFloat = leftOffset

      struct TopLabel {
        static let topOffset: CGFloat = 25.0
      }

      struct BottomLabel {
        static let topOffset: CGFloat = 8.0
      }
    }
  }

}
