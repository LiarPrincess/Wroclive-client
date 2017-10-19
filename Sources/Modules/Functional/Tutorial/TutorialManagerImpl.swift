//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class TutorialManagerImpl: TutorialManager {

  private let defaultsKey = "hasCompletedTutorial"

  var hasCompleted: Bool { return Managers.userDefaults.bool(forKey: defaultsKey) }

  func markAsCompleted() {
    Managers.userDefaults.set(true, forKey: defaultsKey)
  }
}
