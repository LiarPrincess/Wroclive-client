//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

protocol NotificationManager {

  // Post notification
  func post(_ notificationData: NotificationData)

  // Substribe to single notification using @selector
  func subscribe(_ subscriber: Any, to notification: Notification, selector: Selector)

  // Unsubscribe from single notification
  func unsubscribe(_ subscriber: Any, from notification: Notification)
}
