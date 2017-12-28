//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol AppManagerType {

  /// App name (e.g. Wroclive)
  var name: String { get }

  /// App version (e.g. 1.0)
  var version: String { get }

  // App bundle (e.g. pl.nopoint.wroclive)
  var identifier: String { get }

  /// Asks user to rate app in AppStore
  func rateApp()

  /// Present bottom panel to share app
  func showShareActivity(in viewController: UIViewController)

  /// Open app website in Safari
  func openWebsite()
}
