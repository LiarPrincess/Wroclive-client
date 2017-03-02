
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import ReSwift

fileprivate let reducer = CombinedReducer([UserTrackingReducer(), SearchReducer(), BookmarksReducer()])
let store = Store<AppState>(reducer: reducer, state: .initial)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    log.info("Starting application")
    window?.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 1.0)
    return true
  }
}
