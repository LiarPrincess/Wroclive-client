// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

internal enum LineTypeSelectorConstants {
  internal enum Layout {
    /// Proposed height
    internal static let nominalHeight = CGFloat(30.0)
  }

  internal enum TextStyles {
    internal static var title: TextAttributes {
      return TextAttributes(style: .body, color: .tint)
    }
  }
}
