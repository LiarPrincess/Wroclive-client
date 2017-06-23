//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct BookmarksViewControllerConstants {

  struct Layout {
    static let leftInset:  CGFloat = 16.0
    static let rightInset: CGFloat = leftInset

    struct Header {
      static let chevronY:  CGFloat =  8.0

      static let topInset:    CGFloat = 32.0
      static let bottomInset: CGFloat =  8.0

      static let editButtonInsets = UIEdgeInsets(top: 20.0, left: Layout.rightInset, bottom: 4.0, right: Layout.rightInset)
    }

    struct Cell {
      
      // topInset
      // [name]
      // verticalSpacing
      // [linesLabel]
      // verticalSpacing
      // [linesLabel]
      // bottomInset

      static let topInset:    CGFloat = 12.0
      static let bottomInset: CGFloat = topInset

      static let leftInset:  CGFloat = 50.0
      static let rightInset: CGFloat = leftInset

      static let verticalSpacing: CGFloat = 12.0

      static let estimatedHeight: CGFloat = 200.0

      struct LinesLabel {
        static let lineSpacing: CGFloat  = 10.0
      }

    }

    struct Placeholder {
      static let leftInset:  CGFloat = 35.0
      static let rightInset: CGFloat = leftInset

      struct TopLabel {
        static let topOffset: CGFloat = 35.0
      }

      struct BottomLabel {
        static let topOffset: CGFloat = 15.0
      }
    }
  }

  struct Animations {
    static let chevronDismissRelativeDuration: TimeInterval = 0.05
  }

}
