//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct ColorSelectionViewControllerConstants {

  struct Layout {
    static let leftOffset:  CGFloat = 16.0
    static let rightOffset: CGFloat = leftOffset

    struct Presentation {
      static let relativeHeight: CGFloat = 0.75
    }

    struct SectionHeader {
      static let topInset:    CGFloat = 16.0
      static let bottomInset: CGFloat =  8.0

      static let fallbackHeight: CGFloat = topInset + 28.0 + bottomInset
    }

    struct Cell {
      static let margin:  CGFloat =  2.0
      static let minSize: CGFloat = 50.0

      static let cornerRadius: CGFloat = 8.0
    }

    struct BackButton {
      static let imageSize: CGSize = CGSize(width: 20.0, height: 20.0)

      static let leftInset:   CGFloat =  8.0
      static let topInset:    CGFloat = 32.0
      static let rightInset:  CGFloat =  8.0
      static let bottomInset: CGFloat =  8.0
    }
  }
}
