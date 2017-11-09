//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

class TrackingManagerAssert: TrackingManager {

  var result: TrackingResult { assertNotCalled() }

  func start(_ lines: [Line]) {
    assertNotCalled()
  }

  func pause() {
    assertNotCalled()
  }

  func resume() {
    assertNotCalled()
  }
}
