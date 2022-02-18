// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

// swiftlint:disable force_unwrapping
// swiftlint:disable line_length

private let key = UserDefaultsManager.DataKey.notificationToken.value
private let deviceId = UUID(uuidString: "11111111-2222-3333-4444-555555555555")!

// swiftlint:disable:next type_name
final class UserDefaultsManager_NotificationTokenTests: XCTestCase {

  func test_get_notPresent() {
    let apple = AppleUserDefaultsMock()
    let manager = UserDefaultsManager(userDefaults: apple)

    let result = manager.getNotificationToken()
    XCTAssertNil(result)
  }

  func test_get_invalidValue() {
    let apple = AppleUserDefaultsMock()
    let manager = UserDefaultsManager(userDefaults: apple)

    apple.values[key] = Data([1, 2, 3, 4])

    let result = manager.getNotificationToken()
    XCTAssertNil(result)
  }

  func test_get_invalidJSON() {
    let apple = AppleUserDefaultsMock()
    let manager = UserDefaultsManager(userDefaults: apple)

    // Missing device, 'value' instead of 'token'
    let json = "{\"date\":-978294855,\"value\":\"11111111-2222-3333-4444-555555555555\"}"
    apple.values[key] = json.data(using: .utf8)

    let result = manager.getNotificationToken()
    XCTAssertNil(result)
  }

  func test_set_then_get() {
    let token = StoredNotificationToken(
      date: Date(timeIntervalSince1970: 12_345.0),
      deviceId: deviceId,
      token: "11111111-2222-3333-4444-555555555555"
    )

    let apple = AppleUserDefaultsMock()
    let manager = UserDefaultsManager(userDefaults: apple)

    manager.setNotificationToken(token: token)

    if let stored = apple.values[key] as? Data {
      let string = String(bytes: stored, encoding: .utf8)
      let expected = "{\"date\":-978294855,\"token\":\"11111111-2222-3333-4444-555555555555\",\"deviceId\":\"11111111-2222-3333-4444-555555555555\"}"
      XCTAssertEqual(string, expected)
    } else {
      XCTFail("Expected data")
    }

    let result = manager.getNotificationToken()
    XCTAssertEqual(result, token)
  }
}
