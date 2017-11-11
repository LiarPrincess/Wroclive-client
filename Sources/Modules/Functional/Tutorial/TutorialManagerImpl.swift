//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class TutorialManagerImpl: TutorialManager {

  var hasCompleted: Bool {
    return Managers.userDefaults.getBool(.hasCompletedTutorial)
  }

  func markAsCompleted() {
    Managers.userDefaults.setBool(.hasCompletedTutorial, to: true)
  }
}
