//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class TutorialManagerAssert: TutorialManager {

  var hasCompleted: Bool { assertNotCalled() }

  func markAsCompleted() {
    assertNotCalled()
  }
}
