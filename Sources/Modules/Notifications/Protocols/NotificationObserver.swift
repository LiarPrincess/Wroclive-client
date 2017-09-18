//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

@objc protocol NotificationObserver { }

extension NotificationObserver {
  func startObserving(_ notification: Notification, _ selector: Selector) {
    Managers.notification.subscribe(self, to: notification, selector: selector)
  }

  func stopObserving(_ notification: Notification) {
    Managers.notification.unsubscribe(self, from: notification)
  }
}
