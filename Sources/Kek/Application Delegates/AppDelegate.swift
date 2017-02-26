
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import ReSwift

let store = Store<AppState>(reducer: AppReducer(), state: .initial)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window?.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 1.0)
    return true
  }
}
