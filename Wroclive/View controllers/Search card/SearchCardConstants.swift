// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

enum SearchCardConstants {
  enum Layout {
    static let leftInset:   CGFloat = 16.0
    static let rightInset:  CGFloat = leftInset

    static var height: CGFloat { return 0.9 * AppEnvironment.device.screenBounds.height }

    enum Header {
      enum Title {
        static let topOffset: CGFloat = 8.0
      }

      enum Bookmark {
        static let size   = CGSize(width: 23.0, height: 23.0)
        static let insets = UIEdgeInsets(top: 15.0, left: 6.0, bottom: 8.0, right: 16.0)
      }

      enum Search {
        static let insets = UIEdgeInsets(top: 20.0, left: Layout.rightInset, bottom: 4.0, right: Layout.rightInset)
      }

      enum LineType {
        static let topOffset:    CGFloat =  8.0
        static let bottomOffset: CGFloat = 16.0
      }
    }

    enum Placeholder {
      static let leftInset:  CGFloat = 35.0
      static let rightInset: CGFloat = leftInset
    }

    enum LineSelector {
      static let bottomInset: CGFloat = 24.0
    }
  }

  enum TextStyles {
    static var cardTitle: TextAttributes {
      return TextAttributes(style: .headline)
    }

    static var search: TextAttributes {
      return TextAttributes(style: .body, color: .tint)
    }
  }

  enum BookmarksPopup {
    static let delay:     TimeInterval = 0.1
    static let duration:  TimeInterval = 1.4
    static let imageSize: CGSize       = CGSize(width: 64.0, height: 64.0)
  }
}
