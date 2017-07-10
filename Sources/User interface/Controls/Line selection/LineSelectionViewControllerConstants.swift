//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct LineSelectionViewControllerConstants {

  struct Layout {

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

  }
}
