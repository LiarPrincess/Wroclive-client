// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
@testable import WrocliveFramework

class DeviceManagerMock: DeviceManagerType {
  var model = "DEVICE_MODEL"
  var systemName = "DEVICE_SYSTEM_NAME"
  var systemVersion = "DEVICE_SYSTEM_VERSION"

  var screenScale = CGFloat(2)
  var screenBounds = CGRect(x: 0, y: 0, width: 640, height: 1_136)
  var preferredFontSize = CGFloat(17)
}
