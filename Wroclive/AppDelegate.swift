// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import os.log
import ReSwift
import PromiseKit
import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

@UIApplicationMain
public final class AppDelegate: UIResponder, UIApplicationDelegate {

  public var window: UIWindow?

  private var store: Store<AppState>!
  private var environment: Environment!
  private var coordinator: AppCoordinator!
  private var updateScheduler: MapUpdateScheduler!
  private var storeUpdater: DispatchStoreUpdatesFromAppleFrameworks!

  private var log: OSLog {
    return self.environment.log.app
  }

  // MARK: - Launch

  /// Example: Wroclive/1.0 (pl.nopoint.wroclive; iPhone iOS 10.3.1)
  private var appInfo: String {
    let device = self.environment.device
    let bundle = self.environment.bundle
    let deviceInfo = "\(device.model) \(device.systemName) \(device.systemVersion)"
    return "\(bundle.name)/\(bundle.version) (\(bundle.identifier); \(deviceInfo))"
  }

  public func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // This is easily the most important line in the whole app.
    // Every call that interacts with native frameworks has to go through Environment.
    // And don't worry, 'debug' modes will fail to compile in release builds.
//    self.environment = Environment(apiMode: .production)
    self.environment = Environment(apiMode: .debugOffline)

    os_log("application(_:didFinishLaunchingWithOptions:)", log: self.log, type: .info)
    os_log("Starting: %{public}@", log: self.log, type: .info, self.appInfo)

    #if targetEnvironment(simulator)
    let documentDir = self.environment.storage.documentsDirectory.path
    os_log("Simulator documents directory: %{public}@", log: self.log, type: .info, documentDir)
    #endif

    os_log("Initializing redux store", log: self.log, type: .info)
    let state = AppState.load(from: self.environment,
                              bookmarksIfNotSaved: [])
    let middleware = AppState.createMiddleware(environment: self.environment)
    let reducer = AppState.createReducer(environment: self.environment)
    self.store = Store<AppState>(reducer: reducer,
                                 state: state,
                                 middleware: middleware)

    self.storeUpdater = DispatchStoreUpdatesFromAppleFrameworks(
      store: self.store,
      environment: self.environment
    )
    self.storeUpdater.start()

    Theme.setupAppearance()

    os_log("Creating app coordinator", log: self.log, type: .info)
    self.window = UIWindow(frame: self.environment.device.screenBounds)
    self.coordinator = AppCoordinator(window: self.window!,
                                      store: self.store,
                                      environment: self.environment)
    self.coordinator!.start()

    os_log("Creating map update scheduler", log: self.log, type: .info)
    self.updateScheduler = MapUpdateScheduler(store: self.store,
                                              environment: self.environment)

    return true
  }

  // MARK: - Activity

  public func applicationDidBecomeActive(_ application: UIApplication) {
    os_log("applicationDidBecomeActive(_:)", log: self.log, type: .info)
    self.updateScheduler.start()
    self.askForUserLocationAuthorizationIfNotDetermined()
  }

  private func askForUserLocationAuthorizationIfNotDetermined() {
    let delay = self.environment.configuration.timing.locationAuthorizationPromptDelay

    after(seconds: delay).done { _ in
      let authorization = self.store.state.userLocationAuthorization
      if authorization.isNotDetermined {
        os_log("Asking for user location authorization", log: self.log, type: .info)
        let action = UserLocationAuthorizationAction.requestWhenInUseAuthorization
        self.store.dispatch(action)
      }
    }
  }

  public func applicationWillResignActive(_ application: UIApplication) {
    os_log("applicationWillResignActive(_:)", log: self.log, type: .info)
    self.updateScheduler.stop()
  }
}
