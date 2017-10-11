//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var appCoordinator: AppCoordinator!

  let managers = DependencyManagerImpl()

  // MARK: - Launch

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    self.registerManagers()

    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.appCoordinator = AppCoordinator(window: self.window!, managers: self.managers)
    self.appCoordinator.start()

    return true
  }

  private func registerManagers() {
    let notification = NotificationManagerImpl()
    Managers.theme = ThemeManagerImpl(notificationManager: notification)
  }

  // MARK: - Activity

  func applicationDidBecomeActive(_ application: UIApplication) {
    self.managers.tracking.resume()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    self.managers.tracking.pause()
  }
}
