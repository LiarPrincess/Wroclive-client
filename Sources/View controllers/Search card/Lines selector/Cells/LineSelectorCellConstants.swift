//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum LineSelectorCellConstants {
  enum Layout {
    static let margin:  CGFloat =  2.0
    static let minSize: CGFloat = 50.0

    static let cornerRadius: CGFloat = 8.0
  }

  enum TextStyles {
    private static var base: TextAttributes {
      return TextAttributes(style: .body, alignment: .center)
    }

    static var selected:    TextAttributes { return base.withColor(.background) }
    static var notSelected: TextAttributes { return base.withColor(.text) }
  }
}
