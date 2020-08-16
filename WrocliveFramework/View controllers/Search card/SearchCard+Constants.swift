// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// swiftlint:disable nesting

extension SearchCard {

  public enum Constants {

    public static let leftInset = CGFloat(16.0)
    public static let rightInset = leftInset

    // MARK: - Header

    public enum Header {
      public enum Title {
        public static let topOffset = CardPanelConstants.chevronViewSpace + 8.0

        public static var attributes: TextAttributes {
          return TextAttributes(style: .largeTitle)
        }
      }

      public enum Bookmark {
        public static let size = CGSize(width: 23.0, height: 23.0)
        public static let insets = UIEdgeInsets(top: 15.0,
                                                left: 6.0,
                                                bottom: 8.0,
                                                right: 16.0)
      }

      public enum Search {
        // We will make this button bigger using insets
        public static let insets = UIEdgeInsets(top: 20.0,
                                                left: rightInset,
                                                bottom: 4.0,
                                                right: rightInset)

        public static var attributes: TextAttributes {
          return TextAttributes(style: .body, color: .tint)
        }
      }

      public enum LineType {
        public static let topOffset = CGFloat(8.0)
        public static let bottomOffset = CGFloat(16.0)
      }
    }

    // MARK: - Line selector

    public enum LineSelector {
      public static let bottomInset = CGFloat(24.0)
    }

    // MARK: - Placeholder

    public enum Placeholder {
      public static let leftInset = CGFloat(35.0)
      public static let rightInset = leftInset
      public static let verticalSpacing = CGFloat(8.0)

      public static var labelAttributes: TextAttributes {
        return TextAttributes(style: .body, alignment: .center)
      }
    }

    // MARK: - BookmarksPopup

    public enum BookmarksPopup {
      static let delay = TimeInterval(0.1)
      static let duration = TimeInterval(1.4)
      static let imageSize = CGSize(width: 64.0, height: 64.0)
    }
  }
}
