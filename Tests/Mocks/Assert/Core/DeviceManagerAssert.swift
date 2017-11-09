//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class DeviceManagerAssert: DeviceManager {

  // MARK: - Device

  var model:         String { assertNotCalled() }
  var systemName:    String { assertNotCalled() }
  var systemVersion: String { assertNotCalled() }

  // MARK: - Screen

  var screenScale:  CGFloat { assertNotCalled() }
  var screenBounds: CGRect  { assertNotCalled() }

  var preferredFontSize: CGFloat { assertNotCalled() }
}
