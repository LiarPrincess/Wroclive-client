// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

internal enum LineSelectorHeaderViewConstants {

  internal enum Layout {
    internal static let topInset = CGFloat(16.0)
    internal static let bottomInset = CGFloat(8.0)
  }

  internal enum TextStyles {
    internal static var header: TextAttributes {
      return TextAttributes(style: .headline, alignment: .center)
    }
  }
}
