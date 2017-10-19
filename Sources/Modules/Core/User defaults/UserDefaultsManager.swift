//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol UserDefaultsManager {
  func set(_ value: Bool,   forKey defaultName: String)
  func set(_ value: String, forKey defaultName: String)

  func bool  (forKey defaultName: String) -> Bool
  func string(forKey defaultName: String) -> String?
}

extension UserDefaults: UserDefaultsManager {
  func set(_ value: String, forKey defaultName: String) {
    self.setValue(value, forKey: defaultName)
  }
}
