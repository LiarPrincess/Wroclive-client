//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

  // MARK: - Launch

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    AppEnvironment.push(Environment())
    Managers.debug.initialize()
    Managers.theme.applyColorScheme()

    self.window!.rootViewController = MainViewController()
    self.window!.makeKeyAndVisible()

    return true
  }

  // MARK: - Activity

  func applicationDidBecomeActive(_ application: UIApplication) {
    Managers.theme.recalculateFontSizes()
    Managers.map.resumeTracking()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    Managers.map.pauseTracking()
  }
}
