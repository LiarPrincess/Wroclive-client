// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
@testable import WrocliveFramework

private var iso8601Formater: ISO8601DateFormatter {
  let result = ISO8601DateFormatter()
  result.formatOptions.insert(.withFractionalSeconds)
  return result
}

// MARK: - Notifications

struct NotificationModel {
  let id: String
  let url: String
  let author: String
  let date: String
  let body: String
}

func XCTAssertResponse(_ lhs: [WrocliveFramework.Notification],
                       _ rhs: [NotificationModel],
                       file: StaticString = #file,
                       line: UInt = #line) {
  XCTAssertEqual(lhs.count, rhs.count, "Count", file: file, line: line)

  for (got, expected) in zip(lhs, rhs) {
    let id = expected.id
    let gotDate = iso8601Formater.string(from: got.date)

    XCTAssertEqual(got.id, expected.id, "\(id) - id", file: file, line: line)
    XCTAssertEqual(got.url, expected.url, "\(id) - url", file: file, line: line)
    XCTAssertEqual(got.author, expected.author, "\(id) - author", file: file, line: line)
    XCTAssertEqual(gotDate, expected.date, "\(id) - date", file: file, line: line)
    XCTAssertEqual(got.body, expected.body, "\(id) - body", file: file, line: line)
  }
}
