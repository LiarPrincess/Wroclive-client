// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import os.log
import ReSwift
import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

@UIApplicationMain
public final class AppDelegate: UIResponder, UIApplicationDelegate {

  public var window: UIWindow?

  private var store:           Store<AppState>!
  private var coordinator:     AppCoordinator!
  private var updateScheduler: MapUpdateScheduler!

  // MARK: - Launch

  public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let environment = self.createDefaultEnvironment()
    AppEnvironment.push(environment)

    /// 'Wroclive/1.0 (pl.nopoint.wroclive; iPhone iOS 10.3.1)'
    let appInfo: String = {
      let device = AppEnvironment.device
      let bundle = AppEnvironment.bundle
      let deviceInfo = "\(device.model) \(device.systemName) \(device.systemVersion)"
      return "\(bundle.name)/\(bundle.version) (\(bundle.identifier); \(deviceInfo))"
    }()

    os_log("application(_:didFinishLaunchingWithOptions:)", log: AppEnvironment.log.app, type: .info)
    os_log("Starting: %{public}@", log: AppEnvironment.log.app, type: .info, String(describing: appInfo))

    Theme.setupAppearance()

    os_log("Initializing redux store", log: AppEnvironment.log.app, type: .info)
    let state = AppState.load(from: AppEnvironment.storage)
    let middlewares = createMiddlewares()
    self.store = Store<AppState>(reducer: appReducer, state: state, middleware: middlewares)

    os_log("Creating app coordinator", log: AppEnvironment.log.app, type: .info)
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.coordinator = AppCoordinator(self.window!, self.store)
    self.coordinator!.start()

    os_log("Creating map update scheduler", log: AppEnvironment.log.app, type: .info)
    self.updateScheduler = MapUpdateScheduler(self.store)

    return true
  }

  private func createDefaultEnvironment() -> Environment {
    return Environment(
      bundle: BundleManager(),
      debug: DebugManager(),
      device: DeviceManager(),
      log: LogManager(),
      network: NetworkManager(),
      schedulers: SchedulersManager(),
      storage: StorageManager(),
      userLocation: UserLocationManager(),
      configuration: Configuration()
    )
  }

  // MARK: - Activity

  public func applicationDidBecomeActive(_ application: UIApplication) {
    os_log("applicationDidBecomeActive(_:)", log: AppEnvironment.log.app, type: .info)
    Theme.recalculateFontSizes()
    self.updateScheduler.start()
  }

  public func applicationWillResignActive(_ application: UIApplication) {
    os_log("applicationWillResignActive(_:)", log: AppEnvironment.log.app, type: .info)
    self.updateScheduler.stop()
  }
}
