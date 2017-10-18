//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol AppManager {

  /// Open Kek website in Safari
  func openWebsite()

  /// Present bottom panel to share Kek
  func showShareActivity(in viewController: UIViewController)
}
