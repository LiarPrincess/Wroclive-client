//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class NotificationManager: NotificationManagerType {

  private var notificationCenter: NotificationCenter { return NotificationCenter.default }

  func post(_ notificationData: NotificationData) {
    let name = notificationData.notification.name
    self.notificationCenter.post(name: name, object: nil)
  }

  func subscribe(_ subscriber: AnyObject, to notification: Notification, using selector: Selector) {
    self.notificationCenter.addObserver(subscriber, selector: selector, name: notification.name, object: nil)
  }

  func unsubscribe(_ subscriber: AnyObject, from notification: Notification) {
    self.notificationCenter.removeObserver(subscriber, name: notification.name, object: nil)
  }
}
