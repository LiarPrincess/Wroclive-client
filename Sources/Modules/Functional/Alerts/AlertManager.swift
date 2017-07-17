//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol AlertManager {

  // MARK: - Location

  /// Shows alert prompting for authorization change in settings
  func showDeniedAuthorizationAlert(in parent: UIViewController)

  /// Shows alert telling that it is not possible to show user location
  func showRestrictedAuthorizationAlert(in parent: UIViewController)

  // MARK: - Add bookmark

  /// Shows alert notifying that bookmark cannot be created as no line was selected
  func showBookmarkNoLinesSelectedAlert(in parent: UIViewController)

  /// Shows alert for name input when creating new bookmark
  func showBookmarkNameInputAlert(in parent: UIViewController, completed: @escaping (String?) -> ())

  /// Shows alert that contains instructions how to use bookmarks
  func showBookmarkInstructionsAlert(in parent: UIViewController)

}
