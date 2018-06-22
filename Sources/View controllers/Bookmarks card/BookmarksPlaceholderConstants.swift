// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

enum BookmarksPlaceholderViewConstants {
  enum Layout {
    enum Content {
      static let topMargin:   CGFloat = 6.0
      static let lineSpacing: CGFloat = 5.0
    }
  }

  enum TextStyles {
    static var title: TextAttributes {
      return TextAttributes(style: .subheadline, alignment: .center)
    }

    enum Content {
      private static var base: TextAttributes {
        let lineSpacing = Layout.Content.lineSpacing
        return TextAttributes(style: .body, color: .text, alignment: .center, lineSpacing: lineSpacing)
      }

      static var text: TextAttributes { return base.withFont(.text) }
      static var icon: TextAttributes { return base.withFont(.icon) }
    }
  }
}
