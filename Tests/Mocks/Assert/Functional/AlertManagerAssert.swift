//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class AlertManagerAssert: AlertManager {

  // MARK: - Map

  func showDeniedLocationAuthorizationAlert(in parent: UIViewController) {
    assertNotCalled()
  }

  func showGloballyDeniedLocationAuthorizationAlert(in parent: UIViewController) {
    assertNotCalled()
  }

  func showInvalidCityAlert(in parent: UIViewController, completed: @escaping (InvalidCityOptions) -> ()) {
    assertNotCalled()
  }

  // MARK: - Add bookmark

  func showBookmarkNoLinesSelectedAlert(in parent: UIViewController) {
    assertNotCalled()
  }

  func showBookmarkNameInputAlert(in parent: UIViewController, completed: @escaping (String?) -> ()) {
    assertNotCalled()
  }

  // MARK: - Network

  func showNoInternetAlert(in parent: UIViewController, retry: @escaping () -> ()) {
    assertNotCalled()
  }

  func showNetworkingErrorAlert(in parent: UIViewController, retry: @escaping () -> ()) {
    assertNotCalled()
  }
}
