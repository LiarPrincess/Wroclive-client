// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public enum SettingsCardConstants {

  public static let leftInset = CGFloat(16.0)
  public static let rightInset = leftInset

  // MARK: - Header

  public enum Header {
    public static let topInset = CGFloat(8.0)
    public static let bottomInset = CGFloat(8.0)

    public static var titleAttributes: TextAttributes {
      return TextAttributes(style: .largeTitle)
    }
  }

  // MARK: - Table view

  public enum TableView {
    public static let estimatedCellHeight = CGFloat(50.0)
  }

  public enum Cell {
    public enum BottomBorder {
      public static let leftInset = CGFloat(16.0)
    }

    public static var textAttributes: TextAttributes {
      return TextAttributes(style: .body)
    }
  }

  public enum SectionHeader {
    public static let topInset = CGFloat(20.0)
    public static let bottomInset = CGFloat(6.0)

    public static let leftInset = CGFloat(16.0)
    public static let rightInset = leftInset

    public static var titleAttributes: TextAttributes {
      return TextAttributes(style: .headline)
    }
  }

  // MARK: - Footer

  public enum Footer {
    public static let topOffset = CGFloat(5.0)
    public static let bottomOffset = CGFloat(20.0)
    public static let lineSpacing = CGFloat(5.0)

    public static var textAttributes: TextAttributes {
      return TextAttributes(style: .footnote,
                            alignment: .center,
                            lineSpacing: lineSpacing)
    }
  }
}
