//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    self.registerManagers()

    let mainViewController = MainViewController()
    window = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = mainViewController
    window!.makeKeyAndVisible()

    return true
  }

  private func registerManagers() {
    Managers.bookmark    = BookmarksManagerImpl()
    Managers.lines       = LinesManagerImpl()
    Managers.searchState = SearchStateManagerImpl()
    Managers.location    = LocationManagerImpl()
  }
}
