//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class NotificationManagerAssert: NotificationManager {

  func post(_ notificationData: NotificationData) {
    assertNotCalled()
  }

  func subscribe(_ subscriber: AnyObject, to notification: Notification, using selector: Selector) {
    assertNotCalled()
  }

  func unsubscribe(_ subscriber: AnyObject, from notification: Notification) {
    assertNotCalled()
  }
}
