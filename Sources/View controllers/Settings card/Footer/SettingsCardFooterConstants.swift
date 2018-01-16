//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum SettingsCardFooterConstants {
  enum Layout {
    static let topOffset:    CGFloat =  5.0
    static let bottomOffset: CGFloat = 20.0
    static let lineSpacing:  CGFloat =  5.0
  }

  enum TextStyles {
    static var text: TextAttributes {
      return TextAttributes(style: .caption, alignment: .center, lineSpacing: Layout.lineSpacing)
    }
  }
}
