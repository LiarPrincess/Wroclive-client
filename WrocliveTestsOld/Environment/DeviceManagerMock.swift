// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
@testable import WrocliveFramework

class DeviceManagerMock: DeviceManagerType {
  var model: String = "DEVICE_MODEL"
  var systemName: String = "DEVICE_SYSTEM_NAME"
  var systemVersion: String = "DEVICE_SYSTEM_VERSION"

  var screenScale: CGFloat = CGFloat(2)
  var screenBounds: CGRect = CGRect(x: 0, y: 0, width: 640, height: 1_136)
  var preferredFontSize: CGFloat = CGFloat(17)
}
