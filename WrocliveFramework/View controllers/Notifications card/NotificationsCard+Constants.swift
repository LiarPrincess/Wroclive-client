// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// swiftlint:disable nesting

private typealias CardConstants = CardContainer.Constants

extension NotificationsCard {

  public enum Constants {

    public static let leftInset = CGFloat(16.0)
    public static let rightInset = leftInset

    // MARK: - Header

    public enum Header {
      public static let topInset = CardConstants.recommendedContentTopOffset + 8.0
      public static let bottomInset = CGFloat(8.0)

      public static let titleAttributes = TextAttributes(style: .largeTitle)
    }

    // MARK: - Table view

    public enum TableView {
      public static let estimatedCellHeight = CGFloat(200.0)
    }

    public enum Cell {
      public static let topInset = CGFloat(12.0)
      public static let bottomInset = CGFloat(topInset)

      public static let leftInset = CGFloat(Constants.leftInset)
      public static let rightInset = CGFloat(leftInset)

      public enum User {
        public static let nameAttributes = TextAttributes(style: .bodySmallBold)
        public static let usernameAttributes = TextAttributes(style: .bodySmall,
                                                              color: .gray)
      }

      public enum Date {
        public static let attributes = TextAttributes(style: .bodySmall,
                                                      color: .gray)
      }

      public enum Body {
        public static let topMargin = CGFloat(8.0)
        public static let attributes = TextAttributes(style: .bodySmall,
                                                      lineSpacing: 3.0)
      }
    }

    // MARK: - No notifications

    public enum NoNotifications {
      public static let textAttributes = TextAttributes(style: .body)
    }
  }
}
