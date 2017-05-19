
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    log.info("Starting application")

    window = UIWindow(frame: UIScreen.main.bounds)
    window!.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 1.0)
    window!.backgroundColor = .white

    let mainViewController = MainViewController()
    window!.rootViewController = mainViewController
    window!.makeKeyAndVisible()

    //    UINavigationBar.titleFont = UIFont.customPreferredFont(forTextStyle: .headline)
    //    UIBarButtonItem.font = UIFont.customPreferredFont(forTextStyle: .subheadline)

    return true
  }
}
