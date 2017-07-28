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
    Managers.lines       = LinesManagerImpl()
    Managers.bookmark    = BookmarksManagerImpl()
    Managers.search      = SearchManagerImpl()
    Managers.map         = MapManagerImpl()
    Managers.networking  = NetworkingManagerImpl()
    Managers.alert       = AlertManagerImpl()
  }
}
