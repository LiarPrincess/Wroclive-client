//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class AppManagerAssert: AppManager {

  func openWebsite() {
    assertNotCalled()
  }

  func showShareActivity(in viewController: UIViewController) {
    assertNotCalled()
  }
}
