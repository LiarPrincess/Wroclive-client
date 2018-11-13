// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  // swiftlint:disable implicitly_unwrapped_optional
  var store:           Store<AppState>!
  var coordinator:     AppCoordinator!
  var updateScheduler: UpdateScheduler!
  // swiftlint:enable implicitly_unwrapped_optional

  // MARK: - Launch

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    AppEnvironment.pushDefault()
    Theme.setupAppearance()

    let environment = AppEnvironment.current
    let state = loadState(from: environment.storage)
    let middlewares = createMiddlewares(environment)

    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.store  = Store<AppState>(reducer: mainReducer, state: state, middleware: middlewares)
    self.coordinator = AppCoordinator(self.window!, self.store)
    self.updateScheduler = UpdateScheduler(self.store, environment.bundle, environment.schedulers)

    self.coordinator!.start()
    return true
  }

  // MARK: - Activity

  func applicationDidBecomeActive(_ application: UIApplication) {
    Theme.recalculateFontSizes()
    self.updateScheduler.start()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    self.updateScheduler.pause()
  }
}
