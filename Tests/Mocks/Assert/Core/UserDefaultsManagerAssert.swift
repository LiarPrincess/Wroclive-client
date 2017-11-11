//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class UserDefaultsManagerAssert: UserDefaultsManager {

  func getBool(_ key: UserDefaultsBoolKey) -> Bool {
    assertNotCalled()
  }

  func getString(_ key: UserDefaultsStringKey) -> String? {
    assertNotCalled()
  }

  func setBool(_ key: UserDefaultsBoolKey, to value: Bool) {
    assertNotCalled()
  }

  func setString(_ key: UserDefaultsStringKey, to value: String) {
    assertNotCalled()
  }
}
