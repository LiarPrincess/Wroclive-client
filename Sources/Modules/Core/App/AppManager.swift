//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol AppManager {

  /// Open app website in Safari
  func openWebsite()

  /// Present bottom panel to share app
  func showShareActivity(in viewController: UIViewController)
}
