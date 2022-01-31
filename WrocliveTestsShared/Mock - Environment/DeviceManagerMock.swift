// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
@testable import WrocliveFramework

public class DeviceManagerMock: DeviceManagerType {
  public var model = "DEVICE_MODEL"
  public var systemName = "DEVICE_SYSTEM_NAME"
  public var systemVersion = "DEVICE_SYSTEM_VERSION"

  public var screenScale = CGFloat(2)
  public var screenBounds = CGRect(x: 0, y: 0, width: 640, height: 1_136)
  public var preferredFontSize = CGFloat(17)
}
