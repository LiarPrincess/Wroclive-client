//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol AlertManager {

  // MARK: - Add bookmark

  /// Shows alert notifying that bookmark cannot be created as no line was selected
  func showNoLinesSelectedAlert(in parent: UIViewController)

  /// Shows alert for name input when creating new bookmark
  func showBookmarkNameInputAlert(in parent: UIViewController, completed: @escaping (String?) -> ())

  /// Shows alert that contains instructions how to use bookmarks
  func showBookmarkInstructionsAlert(in parent: UIViewController)

}
