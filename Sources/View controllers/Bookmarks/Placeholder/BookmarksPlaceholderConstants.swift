//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum BookmarksPlaceholderViewConstants {
  enum Layout {
    enum Content {
      static let topMargin:   CGFloat = 6.0
      static let lineSpacing: CGFloat = 5.0
    }
  }

  enum TextStyles {
    static var title: TextAttributes {
      return TextAttributes(style: .subheadline, alignment: .center)
    }

    enum Content {
      private static var base: TextAttributes {
        let lineSpacing = Layout.Content.lineSpacing
        return TextAttributes(style: .body, color: .text, alignment: .center, lineSpacing: lineSpacing)
      }

      static var text: TextAttributes {
        var mutableBase = base
        return mutableBase.withFont(.text)
      }

      static var icon: TextAttributes {
        var mutableBase = base
        return mutableBase.withFont(.icon)
      }
    }
  }
}
