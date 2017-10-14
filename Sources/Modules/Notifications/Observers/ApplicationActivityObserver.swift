//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

@objc protocol ApplicationActivityObserver: NotificationObserver {
  func applicationDidBecomeActive()
  func applicationWillResignActive()
}

extension ApplicationActivityObserver where Self: HasNotificationManager {

  func startObservingApplicationActivity() {
    self.startObserving(.applicationDidBecomeActive, #selector(applicationDidBecomeActive))
    self.startObserving(.applicationWillResignActive, #selector(applicationWillResignActive))
  }

  func stopObservingApplicationActivity() {
    self.stopObserving(.applicationDidBecomeActive)
    self.stopObserving(.applicationWillResignActive)
  }
}
