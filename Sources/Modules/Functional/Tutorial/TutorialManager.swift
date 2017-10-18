//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol TutorialManager {

  /// Has the user moved past tutorial?
  var hasCompleted: Bool { get }

  /// Setter for 'hasCompleted'
  func markAsCompleted()
}
