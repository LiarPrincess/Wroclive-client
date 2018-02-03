//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum SettingsCardConstants {
  enum Layout {
    static let leftInset:  CGFloat = 16.0
    static let rightInset: CGFloat = leftInset

    static var height: CGFloat { return 0.75 * Managers.device.screenBounds.height }

    enum Header {
      static let topInset:    CGFloat = 8.0
      static let bottomInset: CGFloat = 8.0
    }

    enum TableView {
      static let estimatedCellHeight: CGFloat = 50.0
    }
  }

  enum TextStyles {
    static var cardTitle:    TextAttributes { return TextAttributes(style: .headline)    }
    static var sectionTitle: TextAttributes { return TextAttributes(style: .subheadline) }
    static var cellText:     TextAttributes { return TextAttributes(style: .body)        }
  }
}
