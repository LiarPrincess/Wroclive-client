// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import os.log
import UIKit
import MapKit
import ReSwift
import PromiseKit
import UserNotifications
import WrocliveFramework

// swiftlint:disable force_unwrapping
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable discouraged_optional_collection

private let appId = "1533532240"

private let configuration = Configuration(
  apiUrl: "https://wroclive.app/api",
  githubUrl: "https://github.com/LiarPrincess/Wroclive-client",
  privacyPolicyUrl: "https://wroclive.app/privacy",
  reportErrorRecipient: "mail@wroclive.app",

  appStore: .init(
    url: "https://itunes.apple.com/app/id\(appId)",
    writeReview: "https://itunes.apple.com/app/id\(appId)?action=write-review"
  ),

  timing: .init(
    vehicleLocationUpdateInterval: 5.0,
    locationAuthorizationPromptDelay: 2.0,
    maxWaitingTimeBeforeShowingNotificationPrompt: 10.0
  )
)

@UIApplicationMain
public final class AppDelegate: UIResponder,
                                UIApplicationDelegate,
                                UserLocationManagerDelegate,
                                NotificationCenterDelegate {

  public var window: UIWindow?

  private var store: Store<AppState>!
  private var environment: Environment!
  private var coordinator: AppCoordinator!
  private var updateScheduler: MapUpdateScheduler!

  private var log: OSLog {
    return self.environment.log.app
  }

  // MARK: - Did finish launching with options

  /// Example: Wroclive/2020.9 (pl.nopoint.wroclive; iPhone iOS 10.3.1)
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
    self.environment = self.createEnvironment(apiMode: .online)
//    self.environment = self.createEnvironment(apiMode: .offline)

    os_log("application(_:didFinishLaunchingWithOptions:)", log: self.log, type: .info)
    os_log("Starting: %{public}@", log: self.log, type: .info, self.appInfo)
    self.logDocumentsDirectoryIfRunningInSimulator()

    os_log("Initializing redux store", log: self.log, type: .debug)
    self.store = self.createStore()

    os_log("Creating (but not starting!) map update scheduler", log: self.log, type: .debug)
    self.updateScheduler = MapUpdateScheduler(
      store: self.store,
      environment: self.environment
    )

    os_log("Setting environment delegates", log: self.log, type: .debug)
    self.environment.userLocation.delegate = self

    os_log("Attempting to register for remote notifications", log: self.log, type: .debug)
    self.environment.notification.registerForRemoteNotifications(delegate: self)

#if DEBUG
    let debugLocale = Localizable.Locale.pl
    let debugLocaleString = String(describing: debugLocale)
    os_log("Setting locale: %{public}@", log: self.log, type: .debug, debugLocaleString)
    Localizable.setLocale(debugLocale)
#endif

    os_log("Setting up theme", log: self.log, type: .debug)
    ColorScheme.initialize()

    os_log("Creating app coordinator", log: self.log, type: .debug)
    self.window = UIWindow(frame: self.environment.device.screenBounds)
    self.coordinator = AppCoordinator(window: self.window!,
                                      store: self.store,
                                      environment: self.environment)
    self.coordinator!.start()

    os_log("application(_:didFinishLaunchingWithOptions:) - finished", log: self.log, type: .debug)
    return true
  }

  // MARK: - Environment

  // Those are the most important lines in the whole app.
  // Every call that interacts with native frameworks has to go through Environment.
  // And don't worry, 'debug' modes will fail to compile in release builds.
  private func createEnvironment(apiMode: Environment.ApiMode) -> Environment {
    return Environment(apiMode: apiMode, configuration: configuration)
  }

  private func logDocumentsDirectoryIfRunningInSimulator() {
#if targetEnvironment(simulator)
    let documentDir = self.environment.storage.documentsDirectory.path
    os_log(
      "Simulator documents directory: %{public}@",
      log: self.log,
      type: .debug,
      documentDir
    )
#endif
  }

  // MARK: - Redux

  private func createStore() -> Store<AppState> {
    let state = AppState.load(
      from: self.environment,
      getInitialBookmarks: { [] },
      getInitialTrackedLines: self.trackAllLinesOnFirstLaunch
    )

    let middleware = AppState.createMiddleware(environment: self.environment)
    let reducer = AppState.createReducer(environment: self.environment)

    return Store<AppState>(
      reducer: reducer,
      state: state,
      middleware: middleware
    )
  }

  // When we launch app for the 1st time we want to show all possible vehicles.
  private func trackAllLinesOnFirstLaunch() -> [Line] {
    os_log(
      "It seems that no lines were previously tracked, trying to start tracking all lines",
      log: self.log,
      type: .info
    )

    _ = self.environment.api.getLines().done { lines in
      assert(self.store != nil, "This should be dispatched via async")
      self.store.dispatch(TrackedLinesAction.startTracking(lines))
      // Since we already downloaded all lines, we may as well cache them:
      self.store.dispatch(ApiAction.setLines(.data(lines)))
    }

    // For now, since we do not have lines (yet).
    return []
  }

  // MARK: - Did become active

  public func applicationDidBecomeActive(_ application: UIApplication) {
    os_log("applicationDidBecomeActive(_:)", log: self.log, type: .info)
    self.updateScheduler.start()
    AuthorizationPrompts.showIfNeeded(environment: self.environment!)
  }

  // MARK: - Will resign active

  public func applicationWillResignActive(_ application: UIApplication) {
    os_log("applicationWillResignActive(_:)", log: self.log, type: .info)
    self.updateScheduler.stop()
  }

  // MARK: - UserLocationManagerDelegate

  public func locationManager(_ manager: UserLocationManagerType,
                              didChangeAuthorization status: UserLocationAuthorization) {
    os_log("locationManager(_:didChangeAuthorization:) to '%{public}@'",
           log: self.log,
           type: .info,
           String(describing: status))

    let action = UserLocationAuthorizationAction.set(status)
    self.store.dispatch(action)
  }

  // MARK: - NotificationCenterDelegate

  public func registerForRemoteNotifications() {
    UIApplication.shared.registerForRemoteNotifications()
  }

  public func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    os_log("application(_:didRegisterForRemoteNotificationsWithDeviceToken:)",
           log: self.log,
           type: .info)
    self.environment.notification.didRegisterForRemoteNotifications(deviceToken: deviceToken)
  }

  public func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    os_log("application(_:didFailToRegisterForRemoteNotificationsWithError:)",
           log: self.log,
           type: .info)
    self.environment.notification.didFailToRegisterForRemoteNotifications(error: error)
  }
}
