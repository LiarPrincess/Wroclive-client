//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class UserDefaultsManager: UserDefaultsManagerType {

  private var defaults: UserDefaults { return UserDefaults.standard }

  func getString(_ key: UserDefaultsStringKey) -> String? {
    return self.defaults.string(forKey: self.getKeyValue(key))
  }

  func setString(_ key: UserDefaultsStringKey, to value: String) {
    self.defaults.setValue(value, forKey: self.getKeyValue(key))
  }

  private func getKeyValue(_ key: UserDefaultsStringKey) -> String {
    switch key {
    case .preferredMapType:   return "String_preferredMapType"
    }
  }
}
