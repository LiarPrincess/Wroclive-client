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

  /// Website (e.g. www.kekapp.pl)
  var website: String { get }

  /// Full website url (e.g. https://www.kekapp.pl)
  var websiteHttps: String { get }

  /// Mail (e.g. mail@kekapp.pl)
  var mail: String { get }

  // MARK: - Tutorial

  /// Has the user moved past tutorial?
  var hasSeenTutorialPresentation: Bool { get set }

  // MARK: - Website

  /// Open Kek website in Safari
  func openWebsite()

  // MARK: - Share

  /// Present bottom panel to share Kek
  func showShareActivity(in viewController: UIViewController)
}
