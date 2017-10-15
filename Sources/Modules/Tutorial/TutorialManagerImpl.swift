//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class TutorialManagerImpl: TutorialManager {

  private let defaultsKey = "hasCompletedTutorial"

  var hasCompleted: Bool { return UserDefaults.standard.bool(forKey: defaultsKey) }

  func markAsCompleted() {
    UserDefaults.standard.set(true, forKey: defaultsKey)
  }
}
