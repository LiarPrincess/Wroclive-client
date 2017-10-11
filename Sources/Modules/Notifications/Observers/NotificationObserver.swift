//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

@objc protocol NotificationObserver { }

extension NotificationObserver where Self: HasNotificationManager {
  func startObserving(_ notification: Notification, _ selector: Selector) {
    self.notification.subscribe(self, to: notification, using: selector)
  }

  func stopObserving(_ notification: Notification) {
    self.notification.unsubscribe(self, from: notification)
  }
}
