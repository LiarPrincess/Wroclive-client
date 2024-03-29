// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// swiftlint:disable nesting

private typealias CardConstants = CardContainer.Constants

extension SearchCard {

  public enum Constants {

    public static let leftInset = CGFloat(16.0)
    public static let rightInset = leftInset

    // MARK: - Header

    public enum Header {
      public enum Title {
        public static let topOffset = CardConstants.recommendedContentTopOffset + 8.0

        public static let attributes = TextAttributes(style: .largeTitle)
      }

      public enum Bookmark {
        // We will make this button bigger using insets
        public static let insets = UIEdgeInsets(top: 15.0,
                                                left: 6.0,
                                                bottom: 0.0,
                                                right: 16.0)
      }

      public enum Search {
        // We will make this button bigger using insets
        public static let insets = UIEdgeInsets(top: 20.0,
                                                left: rightInset,
                                                bottom: 4.0,
                                                right: rightInset)

        public static let attributes = TextAttributes(style: .body,
                                                      color: .tint)
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

    // MARK: - BookmarksPopup

    public enum BookmarksPopup {
      static let delay = TimeInterval(0.1)
      static let duration = TimeInterval(1.4)
      static let imageSize = CGSize(width: 64.0, height: 64.0)
    }
  }
}
