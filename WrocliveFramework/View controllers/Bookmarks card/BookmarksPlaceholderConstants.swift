// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public enum BookmarksPlaceholderViewConstants {
  public enum Layout {
    public enum Content {
      public static let topMargin = CGFloat(6.0)
      public static let lineSpacing = CGFloat(5.0)
    }
  }

  public enum TextStyles {
    public static var title: TextAttributes {
      return TextAttributes(style: .headline, alignment: .center)
    }

    public enum Content {
      private static var base: TextAttributes {
        let lineSpacing = Layout.Content.lineSpacing
        return TextAttributes(style: .body,
                              color: .text,
                              alignment: .center,
                              lineSpacing: lineSpacing)
      }

      public static var text: TextAttributes {
        return Self.base.withFont(.text)
      }

      public static var icon: TextAttributes {
        return Self.base.withFont(.icon)
      }
    }
  }
}
