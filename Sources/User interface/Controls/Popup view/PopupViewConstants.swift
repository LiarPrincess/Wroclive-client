//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct PopupViewConstants {
  struct Layout {
    static let leftInset:  CGFloat = 16.0
    static let rightInset: CGFloat = leftInset

    static let cornerRadius: CGFloat = 16.0

    struct Image {
      static let topOffset: CGFloat = 20.0
      static let size:      CGSize  = CGSize(width: 64.0, height: 64.0)
    }

    struct Title {
      static let topOffset: CGFloat =  14.0
      static let width:     CGFloat = 180.0
    }

    struct Caption {
      static let topOffset:    CGFloat =   6.0
      static let width:        CGFloat = 180.0
      static let bottomOffset: CGFloat =  20.0

      static let lineSpacing: CGFloat = 5.0
    }
  }
}
