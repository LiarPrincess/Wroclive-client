//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum InvalidCityOptions {
  case showDefault
  case ignore
}

// Notify - show information
// Prompt - requires user action
protocol AlertManager {

  // MARK: - Map

  /// Prompt: authorization change in settings
  func showDeniedLocationAuthorizationAlert(in parent: UIViewController)

  /// Notify: it is not possible to show user location
  func showGloballyDeniedLocationAuthorizationAlert(in parent: UIViewController)

  // Notify: current location is far from default city
  func showInvalidCityAlert(in parent: UIViewController, completed: @escaping (InvalidCityOptions) -> ())

  // MARK: - Add bookmark

  /// Notify: bookmark cannot be created as no line was selected
  func showBookmarkNoLinesSelectedAlert(in parent: UIViewController)

  /// Prompt: bookmark name
  func showBookmarkNameInputAlert(in parent: UIViewController, completed: @escaping (String?) -> ())

  // MARK: - Network

  /// Prompt: check network settings. try again
  func showNoInternetAlert(in parent: UIViewController, retry: @escaping () -> ())

  /// Prompt: connection error alert. try again
  func showNetworkingErrorAlert(in parent: UIViewController, retry: @escaping () -> ())
}
