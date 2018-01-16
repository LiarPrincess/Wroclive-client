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
  }

  enum TextStyles {
    static var cardTitle: TextAttributes { return TextAttributes(style: .headline) }
  }

  enum CardPanel {
    static var height: CGFloat { return 0.75 * Managers.device.screenBounds.height }
  }
}
