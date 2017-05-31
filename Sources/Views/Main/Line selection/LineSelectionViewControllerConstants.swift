//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import UIKit

//MARK: - LineSelectionViewControllerConstants

struct LineSelectionViewControllerConstants {

  struct Layout {
    struct Content {
      static let leftOffset:  CGFloat = 25.0
      static let rightOffset: CGFloat = leftOffset
    }

    struct LineTypeSelector {
      static let topOffset:    CGFloat =  4.0
      static let bottomOffset: CGFloat = 10.0
    }

    struct LineCollection {
      struct Section {
        static let headerHeight: CGFloat = 44.0

        static let insets            = UIEdgeInsets(top: 0.0,        left: Content.leftOffset, bottom:  2.0, right: Content.rightOffset)
        static let lastSectionInsets = UIEdgeInsets(top: insets.top, left: insets.left,        bottom: 28.0, right: insets.right)
      }

      struct Cell {
        static let width:     CGFloat = 50.0
        static let height:    CGFloat = 44.0
        static let minMargin: CGFloat = 5.0

        static let cornerRadius: CGFloat = 4.0
        static let borderWidth:  CGFloat = 1.0
      }
    }
  }

}
