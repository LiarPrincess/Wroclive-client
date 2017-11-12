//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class TutorialManagerMock: TutorialManager {

  // MARK: - Properties

  var hasCompleted: Bool

  // MARK: Init

  init(completed: Bool) {
    self.hasCompleted = completed
  }

  // MARK: TutorialManager

  func markAsCompleted() {
    self.hasCompleted = true
  }
}
