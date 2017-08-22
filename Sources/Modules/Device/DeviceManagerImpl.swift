//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class DeviceManagerImpl: DeviceManager {

  /// iPhone, iPod touch
  var model: String { return self.device.model }

  /// iOS, watchOS, tvOS
  var systemName: String { return self.device.systemName }

  /// 10.2
  var systemVersion: String { return self.device.systemVersion }

  private var device: UIDevice { return UIDevice.current }
}
