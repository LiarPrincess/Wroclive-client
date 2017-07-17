//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct SearchViewControllerConstants {

  struct Layout {
    static let leftInset:   CGFloat = 16.0
    static let rightInset:  CGFloat = leftInset

    static let bottomInset: CGFloat = 24.0

    struct Header {
      static let chevronY: CGFloat = 8.0

      // topInset
      // [card title]
      // vertical spacing
      // [line type selector]
      // bottom inset

      static let topInset:    CGFloat = 32.0
      static let bottomInset: CGFloat = 16.0

      static let verticalSpacing: CGFloat = 8.0

      static let bookmarkButtonInsets = UIEdgeInsets(top: 15.0, left: 6.0,               bottom: 8.0, right: 16.0)
      static let searchButtonInsets   = UIEdgeInsets(top: 20.0, left: Layout.rightInset, bottom: 4.0, right: Layout.rightInset)
    }

    struct Placeholder {
      static let leftInset:  CGFloat = 35.0
      static let rightInset: CGFloat = leftInset

      static let verticalSpacing: CGFloat = 8.0
    }
  }

  struct Animations {
    static let chevronDismissRelativeDuration: TimeInterval = 0.05
  }

}
