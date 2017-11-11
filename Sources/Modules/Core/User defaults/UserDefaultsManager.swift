//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum UserDefaultsBoolKey {
  case hasCompletedTutorial
}

enum UserDefaultsStringKey {
  case preferredTintColor
  case preferredTramColor
  case preferredBusColor
}

protocol UserDefaultsManager {

  func getBool  (_ key: UserDefaultsBoolKey)   -> Bool
  func getString(_ key: UserDefaultsStringKey) -> String?

  func setBool  (_ key: UserDefaultsBoolKey,   to value: Bool)
  func setString(_ key: UserDefaultsStringKey, to value: String)
}
