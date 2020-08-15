// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import os.log
import ReSwift
import PromiseKit
import WrocliveFramework

// swiftlint:disable force_unwrapping
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable discouraged_optional_collection

// TODO: Remove overcast from Configuration.init
private let apiBase = "http://127.0.0.1:3000" // "139.59.154.250"
private let websiteUrl = "https://www.overcast.fm"

private let appId = "888422857"
private let shareUrl = "https://itunes.apple.com/us/app/overcast/id\(appId)?mt=8"
private let reviewUrl = "itms-apps://itunes.apple.com/us/app/id\(appId)?action=write-review&mt=8"

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

  // swiftlint:disable:next function_body_length
  public func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Those are the most important lines in the whole app.
    // Every call that interacts with native frameworks has to go through Environment.
    // And don't worry, 'debug' modes will fail to compile in release builds.
    let configuration = Configuration(apiBaseUrl: apiBase,
                                      websiteUrl: websiteUrl,
                                      shareUrl: shareUrl,
                                      writeReviewUrl: reviewUrl)

    #if DEBUG
    self.environment = Environment(apiMode: .debugOffline, configuration: configuration)
    #else
    self.environment = Environment(apiMode: .production, configuration: configuration)
    #endif

    os_log("application(_:didFinishLaunchingWithOptions:)", log: self.log, type: .info)
    os_log("Starting: %{public}@", log: self.log, type: .info, self.appInfo)

    #if targetEnvironment(simulator)
    let documentDir = self.environment.storage.documentsDirectory.path
    os_log("Simulator documents directory: %{public}@", log: self.log, type: .info, documentDir)
    #endif

    os_log("Initializing redux store", log: self.log, type: .info)
    let state = AppState.load(from: self.environment,
                              trackedLinesIfNotSaved: [],
                              bookmarksIfNotSaved: [])
    let middleware = AppState.createMiddleware(environment: self.environment)
    let reducer = AppState.createReducer(environment: self.environment)
    self.store = Store<AppState>(reducer: reducer,
                                 state: state,
                                 middleware: middleware)

    os_log("Adding observers for Apple frameworks", log: self.log, type: .info)
    self.storeUpdater = DispatchStoreUpdatesFromAppleFrameworks(
      store: self.store,
      environment: self.environment
    )
    self.storeUpdater.start()

    os_log("Setting up theme", log: self.log, type: .info)
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
