//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum SettingsCardConstants {
  enum Layout {
    static let leftInset:  CGFloat = 16.0
    static let rightInset: CGFloat = leftInset

    enum Header {
      static let topInset:    CGFloat = 28.0
      static let bottomInset: CGFloat =  8.0
    }

    enum Footer {
      static let topOffset:    CGFloat =  5.0
      static let bottomOffset: CGFloat = 20.0
      static let lineSpacing:  CGFloat =  5.0
    }
  }

  enum TextStyles {
    static var cardTitle: TextAttributes { return TextAttributes(style: .headline) }
    static var footer:    TextAttributes { return TextAttributes(style: .caption, alignment: .center, lineSpacing: Layout.Footer.lineSpacing) }
  }

  enum CardPanel {
    static var height: CGFloat { return 0.75 * Managers.device.screenBounds.height }
  }
}
