//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum BookmarksCardConstants {
  enum Layout {
    static let leftInset:  CGFloat = 16.0
    static let rightInset: CGFloat = leftInset

    enum Header {
      static let topInset:    CGFloat = 28.0
      static let bottomInset: CGFloat =  8.0

      static let editButtonInsets = UIEdgeInsets(top: 20.0, left: Layout.rightInset, bottom: 4.0, right: Layout.rightInset)
    }

    enum TableView {
      static let estimatedCellHeight: CGFloat = 200.0
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

    enum Edit {
      static var edit: TextAttributes {
        return TextAttributes(style: .body, color: .tint)
      }

      static var done: TextAttributes {
        return TextAttributes(style: .bodyBold, color: .tint)
      }
    }
  }

  enum CardPanel {
    static var height: CGFloat { return 0.75 * Managers.device.screenBounds.height }
  }
}