//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

//MARK: - LineSelectionViewControllerConstants

struct LineSelectionViewControllerConstants {
  struct Layout {
    struct Content {
      static let leftOffset:  CGFloat = 25.0
      static let rightOffset: CGFloat = leftOffset
    }

    struct LineTypeSelector {
      static let topOffset: CGFloat = 16.0
    }

    struct LineCollection {
      static let topOffset:    CGFloat = 16.0
      static let bottomOffset: CGFloat = 16.0
    }

    struct CellHeader {
      static let height: CGFloat = 44.0
    }

    struct Cell {
      static let cornerRadius: CGFloat =  4.0
      static let borderWidth:  CGFloat =  1.0
      static let margin:       CGFloat =  4.0
      static let minWidth:     CGFloat = 55.0
    }
  }

  struct LineTypeIndex {
    static let tram = 0
    static let bus  = 1
  }
}
