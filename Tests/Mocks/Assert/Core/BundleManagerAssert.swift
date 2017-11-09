//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class BundleManagerAssert: BundleManager {

  var name:       String { assertNotCalled() }
  var version:    String { assertNotCalled() }
  var identifier: String { assertNotCalled() }

  private func bundleInformation(key: String) -> String? {
    assertNotCalled()
  }
}
