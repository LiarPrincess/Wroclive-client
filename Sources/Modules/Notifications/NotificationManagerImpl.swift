//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class NotificationManagerImpl: NotificationManager {

  func post(_ notificationData: NotificationData) {
    let name = notificationData.notification.name
    NotificationCenter.default.post(name: name, object: nil)
  }

  func subscribe(_ subscriber: Any, to notification: Notification, selector: Selector) {
    NotificationCenter.default.addObserver(subscriber, selector: selector, name: notification.name, object: nil)
  }

  func unsubscribe(_ subscriber: Any, from notification: Notification) {
    NotificationCenter.default.removeObserver(subscriber, name: notification.name, object: nil)
  }
}
