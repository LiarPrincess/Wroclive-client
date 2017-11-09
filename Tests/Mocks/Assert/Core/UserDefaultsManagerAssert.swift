//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class UserDefaultsManagerAssert: UserDefaultsManager {

  func set(_ value: Bool,   forKey defaultName: String) {
    assertNotCalled()
  }

  func set(_ value: String, forKey defaultName: String) {
    assertNotCalled()
  }

  func bool(forKey defaultName: String) -> Bool {
    assertNotCalled()
  }

  func string(forKey defaultName: String) -> String? {
    assertNotCalled()
  }
}
