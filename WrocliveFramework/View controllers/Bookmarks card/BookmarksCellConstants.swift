// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public enum BookmarksCellConstants {
  public enum Layout {
    public static let topInset = CGFloat(10.0)
    public static let bottomInset = CGFloat(topInset)

    public static let leftInset = CGFloat(50.0)
    public static let rightInset = CGFloat(leftInset)

    public enum LinesLabel {
      public static let topMargin = CGFloat(8.0)

      public static let horizontalSpacing = "   "
      public static let lineSpacing = CGFloat(5.0)
      public static let paragraphSpacing = CGFloat(5.0)
    }
  }

  public enum TextStyles {
    public static var name: TextAttributes {
      return TextAttributes(style: .headline, alignment: .center)
    }

    public static var lines: TextAttributes {
      return TextAttributes(style: .body,
                            color: .tint,
                            alignment: .center,
                            lineSpacing: Layout.LinesLabel.lineSpacing,
                            paragraphSpacing: Layout.LinesLabel.paragraphSpacing)
    }
  }
}
