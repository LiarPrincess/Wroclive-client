// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

// swiftlint:disable line_length
// swiftlint:disable force_unwrapping

private typealias Constants = NotificationsCard.Constants.Cell
private let nameAttributes = Constants.User.nameAttributes
private let usernameAttributes = Constants.User.usernameAttributes
private let dateAttributes = Constants.Date.attributes
private let bodyAttributes = Constants.Body.attributes

class NotificationsCellViewModelTests: XCTestCase {

  // MARK: - User

  func test_user() {
    let authorName = "AUTHOR_NAME"
    let authorUsername = "AUTHOR_USERNAME"

    let now = Date(iso8601: "2022-01-01T00:00:00.000Z")!
    let notification = Notification(id: "ID",
                                    url: "URL",
                                    authorName: authorName,
                                    authorUsername: authorUsername,
                                    date: now,
                                    body: "Body")

    let cell = NotificationCellViewModel(notification: notification, now: now)
    let userText = cell.userText

    XCTAssertEqual(userText.string, "AUTHOR_NAME @AUTHOR_USERNAME · ")
    //                               1234567890123456789012345678901

    XCTAssertSubstring(of: userText,
                       startingAt: 0,
                       is: authorName,
                       withAttributes: nameAttributes)

    XCTAssertSubstring(of: userText,
                       startingAt: authorName.count,
                       is: " @AUTHOR_USERNAME · ",
                       withAttributes: usernameAttributes)
  }

  // MARK: - Date

  func test_date_future_returns_now() {
    let notificationDate = Date(iso8601: "2022-01-05T00:00:00.000Z")!
    let now = Date(iso8601: "2022-01-01T00:00:00.000Z")!

    let notification = Notification(id: "ID",
                                    url: "URL",
                                    authorName: "AUTHOR_NAME",
                                    authorUsername: "AUTHOR_USERNAME",
                                    date: notificationDate,
                                    body: "BODY")

    let cell = NotificationCellViewModel(notification: notification, now: now)

    XCTAssertEqual(
      cell.dateText,
      NSAttributedString(string: "Now", attributes: dateAttributes)
    )
  }

  func test_date_now() {
    let notificationDate = Date(iso8601: "2022-01-01T00:00:00.000Z")!
    let now = Date(iso8601: "2022-01-01T00:00:05.000Z")!

    let notification = Notification(id: "ID",
                                    url: "URL",
                                    authorName: "AUTHOR_NAME",
                                    authorUsername: "AUTHOR_USERNAME",
                                    date: notificationDate,
                                    body: "BODY")

    let cell = NotificationCellViewModel(notification: notification, now: now)

    XCTAssertEqual(
      cell.dateText,
      NSAttributedString(string: "Now", attributes: dateAttributes)
    )
  }

  func test_date_minutes() {
    let notificationDate = Date(iso8601: "2022-01-01T00:00:00.000Z")!
    let now = Date(iso8601: "2022-01-01T00:42:00.000Z")!

    let notification = Notification(id: "ID",
                                    url: "URL",
                                    authorName: "AUTHOR_NAME",
                                    authorUsername: "AUTHOR_USERNAME",
                                    date: notificationDate,
                                    body: "BODY")

    let cell = NotificationCellViewModel(notification: notification, now: now)

    XCTAssertEqual(
      cell.dateText,
      NSAttributedString(string: "42m", attributes: dateAttributes)
    )
  }

  func test_date_hours() {
    let notificationDate = Date(iso8601: "2022-01-01T00:00:00.000Z")!
    let now = Date(iso8601: "2022-01-01T03:00:00.000Z")!

    let notification = Notification(id: "ID",
                                    url: "URL",
                                    authorName: "AUTHOR_NAME",
                                    authorUsername: "AUTHOR_USERNAME",
                                    date: notificationDate,
                                    body: "BODY")

    let cell = NotificationCellViewModel(notification: notification, now: now)

    XCTAssertEqual(
      cell.dateText,
      NSAttributedString(string: "3h", attributes: dateAttributes)
    )
  }

  func test_date_days() {
    let notificationDate = Date(iso8601: "2022-01-01T00:00:00.000Z")!
    let now = Date(iso8601: "2022-01-07T00:00:00.000Z")!

    let notification = Notification(id: "ID",
                                    url: "URL",
                                    authorName: "AUTHOR_NAME",
                                    authorUsername: "AUTHOR_USERNAME",
                                    date: notificationDate,
                                    body: "BODY")

    let cell = NotificationCellViewModel(notification: notification, now: now)

    XCTAssertEqual(
      cell.dateText,
      NSAttributedString(string: "6d", attributes: dateAttributes)
    )
  }

  // MARK: - Body

  func test_body_singleLine() {
    let body = "Most Osobowicki - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."

    let now = Date(iso8601: "2022-01-01T00:00:00.000Z")!
    let notification = Notification(id: "ID",
                                    url: "URL",
                                    authorName: "AUTHOR_NAME",
                                    authorUsername: "AUTHOR_USERNAME",
                                    date: now,
                                    body: body)

    let cell = NotificationCellViewModel(notification: notification, now: now)

    XCTAssertEqual(
      cell.bodyText,
      NSAttributedString(string: body, attributes: bodyAttributes)
    )
  }

  func test_body_multipleLines() {
    let body = "⚠ Utrudnienia na godz 13:45 występują w następujących miejscach:\nℹ Most Osobowicki (połamany pantograf).\n🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego."

    let now = Date(iso8601: "2022-01-01T00:00:00.000Z")!
    let notification = Notification(id: "ID",
                                    url: "URL",
                                    authorName: "AUTHOR_NAME",
                                    authorUsername: "AUTHOR_USERNAME",
                                    date: now,
                                    body: body)

    let cell = NotificationCellViewModel(notification: notification, now: now)

    XCTAssertEqual(
      cell.bodyText,
      NSAttributedString(string: body, attributes: bodyAttributes)
    )
  }
}
