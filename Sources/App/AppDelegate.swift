// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window:      UIWindow?
  var coordinator: AppCoordinator?

  // MARK: - Launch

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    AppEnvironment.pushDefault()
    Theme.setupAppearance()

    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.coordinator = AppCoordinator(self.window!)

    self.coordinator!.start()

    return true
  }

  // MARK: - Activity

  func applicationDidBecomeActive(_ application: UIApplication) {
    Theme.recalculateFontSizes()
    AppEnvironment.live.resumeUpdates()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    AppEnvironment.live.pauseUpdates()
  }
}
