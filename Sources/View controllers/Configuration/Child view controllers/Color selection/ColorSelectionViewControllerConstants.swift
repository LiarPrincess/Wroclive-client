//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct ColorSelectionViewControllerConstants {

  struct Layout {
    static let leftOffset:   CGFloat = 16.0
    static let rightOffset:  CGFloat = leftOffset
    static let bottomOffset: CGFloat = 42.0

    struct Presentation {
      static let relativeHeight: CGFloat = 0.75
    }

    struct Section {
      static let topInset:    CGFloat = 12.0
      static let bottomInset: CGFloat = 12.0

      struct Header {
        static let topInset:    CGFloat = 16.0
        static let bottomInset: CGFloat =  8.0
      }

      struct Footer {
        static let height: CGFloat = 1.0
      }
    }

    struct Cell {
      static let margin:  CGFloat =  8.0
      static let minSize: CGFloat = 50.0

      static let cornerRadius: CGFloat = 8.0
    }

    struct BackButton {
      static let imageSize = CGSize(width: 20.0, height: 20.0)
      static let insets    = UIEdgeInsets(top: 30.0, left: 12.0, bottom: 8.0, right: 8.0)
    }
  }
}
