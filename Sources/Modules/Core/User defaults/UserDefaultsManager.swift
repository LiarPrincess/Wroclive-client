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
    case .preferredTintColor:   return "String_preferredTintColor"
    case .preferredTramColor:   return "String_preferredTramColor"
    case .preferredBusColor:    return "String_preferredBusColor"
    }
  }
}
