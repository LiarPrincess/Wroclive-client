//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow? = { return UIWindow(frame: UIScreen.main.bounds) }()

  var appCoordinator: AppCoordinator!

  // MARK: - Launch

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    AppEnvironment.push(Environment())
    Managers.theme.applyColorScheme()

    self.appCoordinator = AppCoordinator(window: self.window!)
    self.appCoordinator.start()

    return true
  }

  // MARK: - Activity

  func applicationDidBecomeActive(_ application: UIApplication) {
    Managers.theme.recalculateFontSizes()
    Managers.tracking.resume()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    Managers.tracking.pause()
  }
}
