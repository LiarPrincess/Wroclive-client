//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class DeviceManagerImpl: DeviceManager {

  var model:         String { return self.device.model }
  var systemName:    String { return self.device.systemName }
  var systemVersion: String { return self.device.systemVersion }

  private var device: UIDevice { return UIDevice.current }
}
