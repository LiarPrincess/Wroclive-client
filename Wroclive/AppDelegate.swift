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

  /// Example: Wroclive/1.0 (pl.nopoint.wroclive; iPhone iOS 10.3.1)
  private var appInfo: String {
    let device = AppEnvironment.device
    let bundle = AppEnvironment.bundle
    let deviceInfo = "\(device.model) \(device.systemName) \(device.systemVersion)"
    return "\(bundle.name)/\(bundle.version) (\(bundle.identifier); \(deviceInfo))"
  }

  public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // This is easily the most important line in the whole app.
    // Every call that interacts with native frameworks has to go through AppEnvironment.
    AppEnvironment.push(.default)

    os_log("application(_:didFinishLaunchingWithOptions:)", log: AppEnvironment.log.app, type: .info)
    os_log("Starting: %{public}@", log: AppEnvironment.log.app, type: .info, String(describing: self.appInfo))

    #if targetEnvironment(simulator)
    let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    os_log("Simulator documents directory: %{public}@", log: AppEnvironment.log.app, type: .info, documentDir ?? "??")
    #endif

    Theme.setupAppearance()

    os_log("Initializing redux store", log: AppEnvironment.log.app, type: .info)
    let state = loadPreviousState()
    let middlewares = createMiddlewares()
    self.store = Store<AppState>(reducer: appReducer, state: state, middleware: middlewares)

    os_log("Creating app coordinator", log: AppEnvironment.log.app, type: .info)
    self.window = UIWindow(frame: AppEnvironment.device.screenBounds)
    self.coordinator = AppCoordinator(self.window!, self.store)
    self.coordinator!.start()

    os_log("Creating map update scheduler", log: AppEnvironment.log.app, type: .info)
    self.updateScheduler = MapUpdateScheduler(self.store)

    return true
  }

  // MARK: - Activity

  public func applicationDidBecomeActive(_ application: UIApplication) {
    os_log("applicationDidBecomeActive(_:)", log: AppEnvironment.log.app, type: .info)
    self.updateScheduler.start()
  }

  public func applicationWillResignActive(_ application: UIApplication) {
    os_log("applicationWillResignActive(_:)", log: AppEnvironment.log.app, type: .info)
    self.updateScheduler.stop()
  }
}
