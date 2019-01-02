// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

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
      return TextAttributes(
        style:            .body,
        color:            .tint,
        alignment:        .center,
        lineSpacing:      Layout.LinesLabel.lineSpacing,
        paragraphSpacing: Layout.LinesLabel.paragraphSpacing)
    }
  }
}
