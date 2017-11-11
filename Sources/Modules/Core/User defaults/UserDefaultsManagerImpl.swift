//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class UserDefaultsManagerImpl: UserDefaultsManager {

  private var defaults: UserDefaults { return UserDefaults.standard }

  func getBool(_ key: UserDefaultsBoolKey)   -> Bool {
    return self.defaults.bool(forKey: self.getKeyValue(key))
  }

  func getString(_ key: UserDefaultsStringKey) -> String? {
    return self.defaults.string(forKey: self.getKeyValue(key))
  }

  func setBool(_ key: UserDefaultsBoolKey,   to value: Bool) {
    self.defaults.set(value, forKey: self.getKeyValue(key))
  }

  func setString(_ key: UserDefaultsStringKey, to value: String) {
    self.defaults.setValue(value, forKey: self.getKeyValue(key))
  }

  private func getKeyValue(_ key: UserDefaultsBoolKey) -> String {
    switch key {
    case .hasCompletedTutorial: return "Bool_hasCompletedTutorial"
    }
  }

  private func getKeyValue(_ key: UserDefaultsStringKey) -> String {
    switch key {
    case .preferredTintColor:   return "String_preferredTintColor"
    case .preferredTramColor:   return "String_preferredTramColor"
    case .preferredBusColor:    return "String_preferredBusColor"
    }
  }
}
