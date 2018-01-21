//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

  // MARK: - Launch

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    AppEnvironment.push(Environment())
    Managers.theme.applyColorScheme()

    self.window!.rootViewController = MainViewController()
    self.window!.makeKeyAndVisible()

    #if DEBUG
//      _ = Observable<Int>
//        .interval(1, scheduler: MainScheduler.instance)
//        .subscribe { _ in print("Resource count \(RxSwift.Resources.total)") }

//      URLCache.shared.removeAllCachedResponses()
    #endif

    return true
  }

  // MARK: - Activity

  func applicationDidBecomeActive(_ application: UIApplication) {
    Managers.theme.recalculateFontSizes()
    Managers.tracking.resume()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    Managers.tracking.pause()
  }
}
