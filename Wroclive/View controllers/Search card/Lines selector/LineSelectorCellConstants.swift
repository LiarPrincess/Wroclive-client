// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

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
