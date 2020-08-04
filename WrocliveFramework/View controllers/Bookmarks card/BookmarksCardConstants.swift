// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public enum BookmarksCardConstants {
  public enum Layout {
    public static let leftInset = CGFloat(16.0)
    public static let rightInset = CGFloat(leftInset)

    public enum Header {
      public enum Title {
        public static let topOffset = CGFloat(8.0)
        public static let bottomOffset = CGFloat(8.0)
      }

      public enum Edit {
        public static let insets = UIEdgeInsets(top: 20.0,
                                                left: Layout.rightInset,
                                                bottom: 4.0,
                                                right: Layout.rightInset)
      }
    }

    public enum TableView {
      public static let estimatedCellHeight = CGFloat(200.0)
    }

    public enum Placeholder {
      public static let leftInset = CGFloat(35.0)
      public static let rightInset = CGFloat(leftInset)
    }
  }

  public enum TextStyles {
    public static var cardTitle: TextAttributes {
      return TextAttributes(style: .largeTitle)
    }

    public enum Edit {
      public static var edit: TextAttributes {
        return TextAttributes(style: .body, color: .tint)
      }

      public static var done: TextAttributes {
        return TextAttributes(style: .bodyBold, color: .tint)
      }
    }
  }
}
