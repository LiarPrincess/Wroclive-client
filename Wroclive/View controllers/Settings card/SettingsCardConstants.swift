// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

enum SettingsCardConstants {
  enum Layout {
    static let leftInset:  CGFloat = 16.0
    static let rightInset: CGFloat = leftInset

    static var height: CGFloat { return 0.75 * AppEnvironment.device.screenBounds.height }

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
