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
    }

    // MARK: - Placeholder

    public enum Placeholder {
      public static let leftInset = CGFloat(35.0)
      public static let rightInset = leftInset
      public static let verticalSpacing = CGFloat(8.0)

      public static let labelAttributes = TextAttributes(style: .body,
                                                         alignment: .center)
    }
  }
}
