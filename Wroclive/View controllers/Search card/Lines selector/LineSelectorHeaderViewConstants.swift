// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

enum LineSelectorHeaderViewConstants {
  enum Layout {
    static let topInset:    CGFloat = 16.0
    static let bottomInset: CGFloat =  8.0
  }

  enum TextStyles {
    static var header: TextAttributes {
      return TextAttributes(style: .subheadline, alignment: .center)
    }
  }
}
