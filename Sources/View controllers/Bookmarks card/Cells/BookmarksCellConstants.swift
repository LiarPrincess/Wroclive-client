//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum BookmarksCellConstants {
  enum Layout {
    static let topInset:    CGFloat = 10.0
    static let bottomInset: CGFloat = topInset

    static let leftInset:  CGFloat = 50.0
    static let rightInset: CGFloat = leftInset

    enum LinesLabel {
      static let topMargin: CGFloat = 8.0

      static let horizontalSpacing: String  = "   "
      static let lineSpacing:       CGFloat = 5.0
      static let paragraphSpacing:  CGFloat = 5.0
    }
  }

  enum TextStyles {
    static var name: TextAttributes {
      return TextAttributes(style: .subheadline, alignment: .center)
    }

    static var lines: TextAttributes {
      let lineSpacing      = Layout.LinesLabel.lineSpacing
      let paragraphSpacing = Layout.LinesLabel.paragraphSpacing
      return TextAttributes(style: .body, color: .tint, alignment: .center, lineSpacing: lineSpacing, paragraphSpacing: paragraphSpacing)
    }
  }
}
