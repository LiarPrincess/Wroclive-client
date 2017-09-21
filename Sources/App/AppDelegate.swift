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
    Managers.location     = LocationManagerImpl()
    Managers.search       = SearchManagerImpl()
    Managers.bookmarks    = BookmarksManagerImpl()
    Managers.tracking     = TrackingManagerImpl()

    Managers.alert        = AlertManagerImpl()
    Managers.network      = NetworkManagerImpl()

    Managers.app          = AppManagerImpl()
    Managers.notification = NotificationManagerImpl()
    Managers.device       = DeviceManagerImpl()
    Managers.appStore     = AppStoreManagerImpl()

    Managers.theme        = ThemeManagerImpl()
  }

  // MARK: - Activity

  func applicationDidBecomeActive(_ application: UIApplication) {
    Managers.tracking.resume()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    Managers.tracking.pause()
  }
}
