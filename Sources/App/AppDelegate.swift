// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift

// swiftlint:disable implicitly_unwrapped_optional

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  private var store:           Store<AppState>!
  private var coordinator:     AppCoordinator!
  private var updateScheduler: UpdateScheduler!

  // MARK: - Launch

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let environment = self.createDefaultEnvironment()
    AppEnvironment.push(environment)

    Theme.setupAppearance()

    let state = loadState()
    let middlewares = createMiddlewares()
    self.store  = Store<AppState>(reducer: mainReducer, state: state, middleware: middlewares)

    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.coordinator = AppCoordinator(self.window!, self.store)

    self.updateScheduler = UpdateScheduler(self.store)

    self.coordinator!.start()
    return true
  }

  private func createDefaultEnvironment() -> Environment {
    return Environment(
      bundle: BundleManager(),
      debug: DebugManager(),
      device: DeviceManager(),
      network: NetworkManager(),
      schedulers: SchedulersManager(),
      storage: StorageManager(),
      userLocation: UserLocationManager(),
      configuration: Configuration()
    )
  }

  // MARK: - Activity

  func applicationDidBecomeActive(_ application: UIApplication) {
    Theme.recalculateFontSizes()
    self.updateScheduler.start()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    self.updateScheduler.stop()
  }
}
