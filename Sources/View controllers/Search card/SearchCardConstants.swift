//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum SearchCardConstants {
  enum Layout {
    static let leftInset:   CGFloat = 16.0
    static let rightInset:  CGFloat = leftInset

    static let bottomInset: CGFloat = 24.0

    enum Header {
      // topInset
      // [card title]
      // vertical spacing
      // [line type selector]
      // bottom inset

      static let topInset:    CGFloat = 28.0
      static let bottomInset: CGFloat = 16.0

      static let verticalSpacing: CGFloat = 8.0

      static let bookmarkButtonInsets = UIEdgeInsets(top: 15.0, left: 6.0,               bottom: 8.0, right: 16.0)
      static let searchButtonInsets   = UIEdgeInsets(top: 20.0, left: Layout.rightInset, bottom: 4.0, right: Layout.rightInset)

      static let bookmarkButtonSize = CGSize(width: 23.0, height: 23.0)
    }

    enum Placeholder {
      static let leftInset:  CGFloat = 35.0
      static let rightInset: CGFloat = leftInset
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

  enum CardPanel {
    static var height: CGFloat { return 0.90 * Managers.device.screenBounds.height }
  }

  enum BookmarksPopup {
    static let delay:     TimeInterval = 0.1
    static let duration:  TimeInterval = 1.4
    static let imageSize: CGSize       = CGSize(width: 64.0, height: 64.0)
  }
}
