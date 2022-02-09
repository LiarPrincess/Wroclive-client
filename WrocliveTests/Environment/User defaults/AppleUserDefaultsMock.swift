// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import WrocliveTestsShared
@testable import WrocliveFramework

final class AppleUserDefaultsMock: AppleUserDefaults {

  var values = [String: Any?]()

  func string(forKey defaultName: String) -> String? {
    guard let any = self.values[defaultName] else {
      return nil
    }

    guard let string = any as? String else {
      fatalError("Expected string, got: '\(String(describing: any))'?")
    }

    return string
  }

  func setValue(_ value: Any?, forKey key: String) {
    self.values[key] = value
  }
}
