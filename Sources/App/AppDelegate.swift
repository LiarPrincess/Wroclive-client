//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  // MARK: - Launch

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    self.registerManagers()

    let mainViewController = MainViewController()
    window = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = mainViewController
    window!.makeKeyAndVisible()

    return true
  }

  private func registerManagers() {
    Managers.map       = MapManagerImpl()
    Managers.search    = SearchManagerImpl()
    Managers.bookmarks = BookmarksManagerImpl()
    Managers.alert     = AlertManagerImpl()
    Managers.network   = NetworkManagerImpl()
  }
}
