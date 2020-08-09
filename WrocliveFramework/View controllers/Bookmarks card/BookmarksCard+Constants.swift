// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

extension BookmarksCard {

  public enum Constants {

    public static let leftInset = CGFloat(16.0)
    public static let rightInset = CGFloat(leftInset)

    // MARK: - Header

    public enum Header {
      public enum Title {
        public static let topOffset = CGFloat(8.0)
        public static let bottomOffset = CGFloat(8.0)

        public static var attributes: TextAttributes {
          return TextAttributes(style: .largeTitle)
        }
      }

      public enum Edit {
        public static let insets = UIEdgeInsets(top: 20.0,
                                                left: Constants.rightInset,
                                                bottom: 4.0,
                                                right: Constants.rightInset)

        public static var editAttributes: TextAttributes {
          return TextAttributes(style: .body, color: .tint)
        }

        public static var doneAttributes: TextAttributes {
          return TextAttributes(style: .bodyBold, color: .tint)
        }
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
        public static var attributes: TextAttributes {
          return TextAttributes(style: .headline, alignment: .center)
        }
      }

      public enum Lines {
        public static let topMargin = CGFloat(8.0)

        public static let horizontalSpacing = "   "
        public static let lineSpacing = CGFloat(5.0)
        public static let paragraphSpacing = CGFloat(5.0)

        public static var attributes: TextAttributes {
          return TextAttributes(style: .body,
                                color: .tint,
                                alignment: .center,
                                lineSpacing: lineSpacing,
                                paragraphSpacing: paragraphSpacing)
        }
      }
    }

    // MARK: - Placeholder

    public enum Placeholder {
      public static let leftInset = CGFloat(35.0)
      public static let rightInset = CGFloat(leftInset)
      public static let topMargin = CGFloat(6.0)
      public static let lineSpacing = CGFloat(5.0)

      public enum Title {
        public static var attributes: TextAttributes {
          return TextAttributes(style: .headline, alignment: .center)
        }
      }

      public enum Content {
        private static var base: TextAttributes {
          return TextAttributes(style: .body,
                                color: .text,
                                alignment: .center,
                                lineSpacing: lineSpacing)
        }

        public static var textAttributes: TextAttributes {
          return Self.base.withFont(.text)
        }

        public static var iconAttributes: TextAttributes {
          return Self.base.withFont(.icon)
        }
      }
    }
  }
}
