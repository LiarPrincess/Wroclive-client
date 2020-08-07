// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public enum SearchCardConstants {
  public enum Layout {
    public static let leftInset = CGFloat(16.0)
    public static let rightInset = leftInset

    public enum Header {
      public enum Title {
        public static let topOffset = CGFloat(8.0)
      }

      public enum Bookmark {
        public static let size = CGSize(width: 23.0, height: 23.0)
        public static let insets = UIEdgeInsets(top: 15.0,
                                                left: 6.0,
                                                bottom: 8.0,
                                                right: 16.0)
      }

      public enum Search {
        public static let insets = UIEdgeInsets(top: 20.0,
                                                left: Layout.rightInset,
                                                bottom: 4.0,
                                                right: Layout.rightInset)
      }

      public enum LineType {
        public static let topOffset = CGFloat(8.0)
        public static let bottomOffset = CGFloat(16.0)
      }
    }

    public enum Placeholder {
      public static let leftInset = CGFloat(35.0)
      public static let rightInset = leftInset
    }

    public enum LineSelector {
      public static let bottomInset = CGFloat(24.0)
    }
  }

  public enum TextStyles {
    public static var cardTitle: TextAttributes {
      return TextAttributes(style: .largeTitle)
    }

    public static var search: TextAttributes {
      return TextAttributes(style: .body, color: .tint)
    }
  }

  public enum BookmarksPopup {
    static let delay = TimeInterval(0.1)
    static let duration = TimeInterval(1.4)
    static let imageSize = CGSize(width: 64.0, height: 64.0)
  }
}
