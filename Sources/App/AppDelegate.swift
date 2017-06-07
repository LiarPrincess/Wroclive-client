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

    UINavigationBar.titleFont = Theme.current.font.headline
    UIBarButtonItem.font      = Theme.current.font.body

    window = UIWindow(frame: UIScreen.main.bounds)
    window!.tintColor       = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 1.0)
    window!.backgroundColor = UIColor.black

    let mainViewController     = MainViewController()
    window!.rootViewController = mainViewController
    window!.makeKeyAndVisible()

    return true
  }
}
