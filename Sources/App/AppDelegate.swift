//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    logger.info("Starting application")

    let mainViewController = MainViewController()
//    let mainViewController = SearchViewController()
//    let mainViewController = BookmarksViewController()
    window = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = mainViewController
    window!.makeKeyAndVisible()

    return true
  }
}
