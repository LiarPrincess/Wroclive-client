// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  let window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

  // MARK: - Launch

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    EnvironmentStack.push(Environment())
    self.applyColorScheme()

    self.window!.rootViewController = MainViewController()
    self.window!.makeKeyAndVisible()

    return true
  }

  private func applyColorScheme() {
    let tintColor = AppEnvironment.theme.colors.tint
    let barStyle  = AppEnvironment.theme.colors.barStyle

    UIApplication.shared.delegate?.window??.tintColor = tintColor

    UIWindow.appearance().tintColor = tintColor
    UIView.appearance().tintColor   = tintColor

    // Make user location pin blue
    MKAnnotationView.appearance().tintColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)

    UIToolbar.appearance().barStyle       = barStyle
    UINavigationBar.appearance().barStyle = barStyle
    UINavigationBar.appearance().titleTextAttributes = TextAttributes(style: .bodyBold).value
  }

  // MARK: - Activity

  func applicationDidBecomeActive(_ application: UIApplication) {
    AppEnvironment.theme.recalculateFontSizes()
    AppEnvironment.live.resumeUpdates()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    AppEnvironment.live.pauseUpdates()
  }
}
