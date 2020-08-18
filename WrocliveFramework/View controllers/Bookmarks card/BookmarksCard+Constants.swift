// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// swiftlint:disable nesting

extension BookmarksCard {

  public enum Constants {

    public static let leftInset = CGFloat(16.0)
    public static let rightInset = CGFloat(leftInset)

    // MARK: - Header

    public enum Header {
      public enum Title {
        public static let topOffset = CardPanelConstants.chevronViewSpace + 8.0
        public static let bottomOffset = CGFloat(8.0)

        public static let attributes = TextAttributes(style: .largeTitle)
      }

      public enum Edit {
        public static let insets = UIEdgeInsets(top: 20.0,
                                                left: Constants.rightInset,
                                                bottom: 4.0,
                                                right: Constants.rightInset)

        public static let editAttributes = TextAttributes(style: .body, color: .tint)
        public static let doneAttributes = TextAttributes(style: .bodyBold, color: .tint)
      }
    }

    // MARK: - Table view

    public enum TableView {
      public static let estimatedCellHeight = CGFloat(200.0)
    }

    public enum Cell {
      public static let topInset = CGFloat(10.0)
      public static let bottomInset = CGFloat(topInset)

      public static let leftInset = CGFloat(50.0)
      public static let rightInset = CGFloat(leftInset)

      public enum Name {
        public static let attributes = TextAttributes(style: .headline,
                                                      alignment: .center)
      }

      public enum Lines {
        public static let topMargin = CGFloat(8.0)
        public static let horizontalSpacing = "   "

        public static let attributes = TextAttributes(style: .body,
                                                      color: .tint,
                                                      alignment: .center,
                                                      lineSpacing: 5.0,
                                                      paragraphSpacing: 5.0)
      }
    }

    // MARK: - Placeholder

    public enum Placeholder {
      public static let leftInset = CGFloat(35.0)
      public static let rightInset = CGFloat(leftInset)
      public static let topMargin = CGFloat(6.0)

      public enum Title {
        public static let attributes = TextAttributes(style: .headline,
                                                      alignment: .center)
      }

      public enum Content {
        public static let textAttributes = TextAttributes(style: .body,
                                                          alignment: .center,
                                                          lineSpacing: 5.0)
      }
    }
  }
}
