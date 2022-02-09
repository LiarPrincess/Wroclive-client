// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

private let preferredMapTypeKey = UserDefaultsManager.StringKey.preferredMapType.value

final class UserDefaultsManagerTests: XCTestCase {

  // MARK: - Preferred map type

  func test_preferredMapType_get_notPresent() {
    let apple = AppleUserDefaultsMock()
    let manager = UserDefaultsManager(userDefaults: apple)

    let result = manager.getPreferredMapType()
    XCTAssertNil(result)
  }

  func test_preferredMapType_unknownValue() {
    let apple = AppleUserDefaultsMock()
    let manager = UserDefaultsManager(userDefaults: apple)

    apple.values[preferredMapTypeKey] = "UNKNOWN_VALUE"

    let result = manager.getPreferredMapType()
    XCTAssertNil(result)
  }

  func test_preferredMapType_set_then_get_knownValues() {
    let knownValues: [(String, MapType)] = [
      ("standard", MapType.standard),
      ("satellite", MapType.satellite),
      ("hybrid", MapType.hybrid)
    ]

    let apple = AppleUserDefaultsMock()
    let manager = UserDefaultsManager(userDefaults: apple)

    for (string, mapType) in knownValues {
      manager.setPreferredMapType(mapType: mapType)

      if let stored = apple.values[preferredMapTypeKey] as? String? {
        XCTAssertEqual(stored, string)
      } else {
        XCTFail("Expected string")
      }

      let result = manager.getPreferredMapType()
      XCTAssertEqual(result, mapType)
    }
  }
}
