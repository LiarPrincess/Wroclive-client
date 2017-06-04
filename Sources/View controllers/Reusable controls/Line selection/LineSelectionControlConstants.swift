//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct LineSelectionControlConstants {

  struct Layout {
    struct Section {
      static let headerHeight: CGFloat = 44.0

      static let insets            = UIEdgeInsets(top: 0.0,        left: 0.0,         bottom:  2.0, right: 0.0)
      static let lastSectionInsets = UIEdgeInsets(top: insets.top, left: insets.left, bottom: 28.0, right: insets.right)
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