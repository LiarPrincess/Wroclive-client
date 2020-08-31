// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// swiftlint:disable nesting

extension SettingsCard {

  public enum Constants {

    public static let leftInset = CGFloat(16.0)
    public static let rightInset = leftInset

    // MARK: - Header

    public enum Header {
      public static let topInset = CardPanelConstants.recommendedContentTopOffset + 8.0
      public static let bottomInset = CGFloat(8.0)

      public static let titleAttributes = TextAttributes(style: .largeTitle)
    }

    // MARK: - Table view

    public enum TableView {
      public static let estimatedCellHeight = CGFloat(50.0)
    }

    public enum LinkCell {
      public enum BottomBorder {
        public static let leftInset = CGFloat(16.0)
      }

      public static let textAttributes = TextAttributes(style: .body)
    }

    public enum MapTypeCell {
      static let topInset = CGFloat(8.0)
      static let bottomInset = CGFloat(2.0)

      static let leftInset = CGFloat(16.0)
      static let rightInset = leftInset

      /// Proposed height
      static let nominalHeight = CGFloat(30.0)
    }

    public enum SectionHeader {
      public static let topInset = CGFloat(16.0)
      public static let bottomInset = CGFloat(6.0)

      public static let leftInset = CGFloat(16.0)
      public static let rightInset = leftInset

      public static let titleAttributes = TextAttributes(style: .headline)
    }

    // MARK: - Footer

    public enum Footer {
      public static let topOffset = CGFloat(16.0)
      public static let bottomOffset = CGFloat(20.0)
      public static let lineSpacing = CGFloat(5.0)

      public static let textAttributes = TextAttributes(style: .footnote,
                                                        alignment: .center,
                                                        lineSpacing: lineSpacing)
    }
  }
}
