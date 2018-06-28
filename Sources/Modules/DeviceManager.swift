// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// sourcery: manager
class DeviceManager: DeviceManagerType {

  // MARK: - Device

  var model:         String { return self.device.model }
  var systemName:    String { return self.device.systemName }
  var systemVersion: String { return self.device.systemVersion }

  private var device: UIDevice { return UIDevice.current }

  // MARK: - Screen

  var screenScale:  CGFloat { return screen.scale }
  var screenBounds: CGRect  { return screen.bounds }

  private var screen: UIScreen { return UIScreen.main }

  var preferredFontSize: CGFloat  {
    return UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
  }
}
