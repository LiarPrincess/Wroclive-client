//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum UserDefaultsStringKey {
  case preferredMapType
}

protocol UserDefaultsManagerType {

  /// Get value for given key from store
  func getString(_ key: UserDefaultsStringKey) -> String?

  /// Store given value
  func setString(_ key: UserDefaultsStringKey, to value: String)
}
