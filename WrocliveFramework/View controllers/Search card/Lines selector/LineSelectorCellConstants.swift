// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public enum LineSelectorCellConstants {
  public enum Layout {
    public static let margin:  CGFloat =  2.0
    public static let minSize: CGFloat = 50.0

    public static let cornerRadius: CGFloat = 8.0
  }

  public enum TextStyles {
    private static var base: TextAttributes {
      return TextAttributes(style: .body, alignment: .center)
    }

    public static var selected:    TextAttributes { return base.withColor(.background) }
    public static var notSelected: TextAttributes { return base.withColor(.text) }
  }
}