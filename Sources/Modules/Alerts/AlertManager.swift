//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol AlertManager {

  // MARK: - Map

  /// Prompt for authorization change in settings
  func showDeniedLocationAuthorizationAlert(in parent: UIViewController)

  /// Prompt that it is not possible to show user location
  func showGloballyDeniedLocationAuthorizationAlert(in parent: UIViewController)

  // MARK: - Add bookmark

  /// Shows alert notifying that bookmark cannot be created as no line was selected
  func showBookmarkNoLinesSelectedAlert(in parent: UIViewController)

  /// Prompt for name input when creating new bookmark
  func showBookmarkNameInputAlert(in parent: UIViewController, completed: @escaping (String?) -> ())

  // MARK: - Network

  /// Prompt user to check his/her network settings and try again
  func showNoInternetAlert(in parent: UIViewController, retry: @escaping () -> ())

  /// Show connection error alert and prompt to try again
  func showNetworkingErrorAlert(in parent: UIViewController, retry: @escaping () -> ())
}
