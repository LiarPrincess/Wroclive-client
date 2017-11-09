//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import UIKit

class AppStoreManagerAssert: AppStoreManager {

  func buyUpgrade() {
    assertNotCalled()
  }

  func restorePurchase() {
    assertNotCalled()
  }

  func rateApp() {
    assertNotCalled()
  }
}
