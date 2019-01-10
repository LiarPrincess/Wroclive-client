// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public enum SettingsCardConstants {
  public enum Layout {
    public static let leftInset:  CGFloat = 16.0
    public static let rightInset: CGFloat = leftInset

    public enum Header {
      public static let topInset:    CGFloat = 8.0
      public static let bottomInset: CGFloat = 8.0
    }

    public enum TableView {
      public static let estimatedCellHeight: CGFloat = 50.0
    }
  }

  public enum TextStyles {
    public static var cardTitle:    TextAttributes { return TextAttributes(style: .headline)    }
    public static var sectionTitle: TextAttributes { return TextAttributes(style: .subheadline) }
    public static var cellText:     TextAttributes { return TextAttributes(style: .body)        }
  }
}
