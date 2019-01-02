// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

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
