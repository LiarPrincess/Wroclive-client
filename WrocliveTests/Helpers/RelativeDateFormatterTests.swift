// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
@testable import WrocliveFramework

// swiftlint:disable force_unwrapping

class RelativeDateFormatterTests: XCTestCase {

  func test_future() {
    let present = Date(iso8601: "2022-01-01T00:00:00.000Z")!

    let dates = [
      Date(iso8601: "2023-01-01T00:00:00.000Z")!,
      Date(iso8601: "2023-02-01T00:00:00.000Z")!,
      Date(iso8601: "2022-01-02T00:00:00.000Z")!,
      Date(iso8601: "2022-01-01T01:00:00.000Z")!,
      Date(iso8601: "2022-01-01T00:01:00.000Z")!,
      Date(iso8601: "2022-01-01T00:00:01.000Z")!,
      Date(iso8601: "2022-01-01T00:00:00.001Z")!
    ]

    for past in dates {
      let formatter = RelativeDateFormatter()
      let result = formatter.string(present: present, past: past)
      XCTAssertEqual(result, "Future", String(describing: past))
    }
  }

  func test_underMinute_returnsNow() {
    let past = Date(iso8601: "2022-01-01T00:00:00.000Z")!

    let dates = [
      Date(iso8601: "2022-01-01T00:00:00.001Z")!,
      Date(iso8601: "2022-01-01T00:00:00.999Z")!,
      Date(iso8601: "2022-01-01T00:00:01.000Z")!,
      Date(iso8601: "2022-01-01T00:00:59.999Z")!
    ]

    for present in dates {
      let formatter = RelativeDateFormatter()
      let result = formatter.string(present: present, past: past)
      XCTAssertEqual(result, "Now", String(describing: present))
    }
  }

  func test_aboveMinute_belowHour_returnsMinutes() {
    let formatter = RelativeDateFormatter()
    let past = Date(iso8601: "2022-01-01T00:00:00.000Z")!

    let minute = Date(iso8601: "2022-01-01T00:01:00.000Z")!
    let minuteResult = formatter.string(present: minute, past: past)
    XCTAssertEqual(minuteResult, "1m")

    let almostHour = Date(iso8601: "2022-01-01T00:59:59.999Z")!
    let almostHourResult = formatter.string(present: almostHour, past: past)
    XCTAssertEqual(almostHourResult, "59m")
  }

  func test_aboveHour_belowDay_returnsHours() {
    let formatter = RelativeDateFormatter()
    let past = Date(iso8601: "2022-01-01T00:00:00.000Z")!

    let hour = Date(iso8601: "2022-01-01T01:00:00.000Z")!
    let hourResult = formatter.string(present: hour, past: past)
    XCTAssertEqual(hourResult, "1h")

    let almostDay = Date(iso8601: "2022-01-01T23:59:59.999Z")!
    let almostDayResult = formatter.string(present: almostDay, past: past)
    XCTAssertEqual(almostDayResult, "23h")
  }

  func test_aboveDay_returnsDays() {
    let formatter = RelativeDateFormatter()
    let past = Date(iso8601: "2022-01-01T00:00:00.000Z")!

    let day1 = Date(iso8601: "2022-01-02T00:00:00.000Z")!
    let day1Result = formatter.string(present: day1, past: past)
    XCTAssertEqual(day1Result, "1d")

    let day2 = Date(iso8601: "2022-01-03T13:00:42.999Z")!
    let day2Result = formatter.string(present: day2, past: past)
    XCTAssertEqual(day2Result, "2d")
  }
}
