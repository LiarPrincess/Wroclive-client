// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private typealias Constants = NotificationsCard.Constants.Cell

private let dateFormatter = RelativeDateFormatter()

public struct NotificationCellViewModel: Equatable {

  public let notification: Notification

  public let userText: NSAttributedString
  public let dateText: NSAttributedString
  public let bodyText: NSAttributedString

  public init(notification: Notification, now: Date) {
    self.notification = notification

    let userText = NSMutableAttributedString(
      string: notification.authorName,
      attributes: Constants.User.nameAttributes
    )

    let usernameText = NSAttributedString(
      string: " @\(notification.authorUsername) · ",
      attributes: Constants.User.usernameAttributes
    )

    userText.append(usernameText)
    self.userText = userText

    let date = notification.date
    let dateInterval =
      dateFormatter.localizedStringWithNowInsteadOfFuture(present: now, past: date)

    self.dateText = NSAttributedString(
      string: dateInterval,
      attributes: Constants.Date.attributes
    )

    self.bodyText = NSAttributedString(
      string: notification.body,
      attributes: Constants.Body.attributes
    )
  }

  public static func == (lhs: NotificationCellViewModel,
                         rhs: NotificationCellViewModel) -> Bool {
    return lhs.notification == rhs.notification
  }
}
