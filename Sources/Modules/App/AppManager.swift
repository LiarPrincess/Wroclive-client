//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol AppManager {

  // MARK: - Info

  /// App name (e.g. Kek)
  var name: String { get }

  /// App version (e.g. 1.0)
  var version: String { get }

  // App bundle (e.g. pl.kekapp.kek)
  var bundle: String { get }

  // MARK: - Tutorial

  /// Has the user moved past tutorial?
  var hasSeenTutorialPresentation: Bool { get set }

  // MARK: - External

  /// Open Kek website in Safari
  func openWebsite()

  /// Present bottom panel to share Kek
  func showShareActivity(in viewController: UIViewController)
}
