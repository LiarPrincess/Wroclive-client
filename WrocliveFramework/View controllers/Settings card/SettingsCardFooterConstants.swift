// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public enum SettingsCardFooterConstants {
  public enum Layout {
    public static let topOffset:    CGFloat =  5.0
    public static let bottomOffset: CGFloat = 20.0
    public static let lineSpacing:  CGFloat =  5.0
  }

  public enum TextStyles {
    public static var text: TextAttributes {
      return TextAttributes(style: .footnote, alignment: .center, lineSpacing: Layout.lineSpacing)
    }
  }
}
