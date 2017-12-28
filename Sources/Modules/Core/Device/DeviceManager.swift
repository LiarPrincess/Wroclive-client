//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

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
