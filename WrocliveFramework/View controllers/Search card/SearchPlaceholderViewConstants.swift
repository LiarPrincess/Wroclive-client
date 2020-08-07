// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public enum SearchPlaceholderViewConstants {
  public enum Layout {
    public static let verticalSpacing = CGFloat(8.0)
  }

  public enum TextStyles {
    public static var label: TextAttributes {
      return TextAttributes(style: .body, alignment: .center)
    }
  }
}
