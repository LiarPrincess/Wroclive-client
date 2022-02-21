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

// swiftlint:disable weak_delegate
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
public final class AppDelegate: UIResponder, UIApplicationDelegate {

  public var window: UIWindow?

  private var store: Store<AppState>!
  private var environment: Environment!
  private var coordinator: AppCoordinator!
  private var updateScheduler: MapUpdateScheduler!

  private var userLocationDelegate: UserLocationDelegate!
  private var remoteNotificationDelegate: RemoteNotificationDelegate!

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

  // swiftlint:disable:next function_body_length
  public func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Those are the most important lines in the whole app.
    // Every call that interacts with native frameworks has to go through Environment.
    // And don't worry, 'debug' modes will fail to compile in release builds.
    self.environment = Environment(apiMode: .online, configuration: configuration)
//    self.environment = Environment(apiMode: .offline, configuration: configuration)

    os_log("application(_:didFinishLaunchingWithOptions:)", log: self.log, type: .info)
    os_log("Starting: %{public}@", log: self.log, type: .info, self.appInfo)
    self.logUrlIfStartingWithRemoteNotification(launchOptions: launchOptions)
    self.logDocumentsDirectoryIfRunningInSimulator()

    os_log("Initializing redux store", log: self.log, type: .debug)
    self.store = self.createStore()

    os_log("Setting environment delegates", log: self.log, type: .debug)
    self.userLocationDelegate = UserLocationDelegate(
      store: self.store,
      environment: self.environment
    )
    self.environment.userLocation.delegate = self.userLocationDelegate

    self.remoteNotificationDelegate = RemoteNotificationDelegate(
      environment: self.environment
    )
    self.environment.remoteNotifications.delegate = self.remoteNotificationDelegate

    os_log("Creating (but not starting!) map update scheduler", log: self.log, type: .debug)
    self.updateScheduler = MapUpdateScheduler(
      store: self.store,
      environment: self.environment
    )

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

    // Remote notification can only trigger changes after the coordinator was started!
    self.remoteNotificationDelegate.coordinator = self.coordinator

    os_log("Attempting to register for remote notifications", log: self.log, type: .debug)
    self.environment.remoteNotifications.registerForRemoteNotifications()

    os_log("application(_:didFinishLaunchingWithOptions:) - finished", log: self.log, type: .debug)
    return true
  }

  private func logUrlIfStartingWithRemoteNotification(
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) {
    let result = RemoteNotificationDelegate.getRemoteNotificationUrl(launchOptions: launchOptions)

    switch result {
    case .url(let url):
      os_log("Launching as a result of remote notification with url: %{public}@",
             log: self.log,
             type: .debug,
             url)

    case .noUrl:
      os_log("Launching as a result of remote notification without url",
             log: self.log,
             type: .debug)

    case .noRemoteNotification:
      break
    }
  }

  private func logDocumentsDirectoryIfRunningInSimulator() {
#if targetEnvironment(simulator)
    let documentDir = self.environment.storage.documentsDirectory.path
    os_log("Simulator documents directory: %{public}@",
           log: self.log,
           type: .debug,
           documentDir)
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

    return Store<AppState>(reducer: reducer, state: state, middleware: middleware)
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

#if DEBUG
    // Make some space in logs, for readability.
    print("\n\n")
#endif
  }

  // MARK: - Remote notifications

  public func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    os_log("application(_:didRegisterForRemoteNotificationsWithDeviceToken:)",
           log: self.log,
           type: .info)

    _ = self.environment.remoteNotifications.didRegisterForRemoteNotifications(
      deviceToken: deviceToken
    )
  }

  public func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    os_log("application(_:didFailToRegisterForRemoteNotificationsWithError:)",
           log: self.log,
           type: .info)

    self.environment.remoteNotifications.didFailToRegisterForRemoteNotifications(
      error: error
    )
  }
}
