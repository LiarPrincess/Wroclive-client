//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

//MARK: - BookmarksViewControllerConstants

struct BookmarksViewControllerConstants {

  struct Layout {

    struct Cell {

      static let topOffset:    CGFloat = 8.0
      static let bottomOffset: CGFloat = 8.0

      static let leftOffset:  CGFloat = 40.0
      static let rightOffset: CGFloat = leftOffset

      struct TramLines {
        static let topOffset: CGFloat = 6.0
      }

      struct BusLines {
        static let topOffset: CGFloat = 6.0
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
