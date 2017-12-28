//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

protocol NotificationManagerType {

  /// Post notification
  func post(_ notificationData: NotificationData)

  /// Substribe to single notification using @selector
  func subscribe(_ subscriber: AnyObject, to notification: Notification, using selector: Selector)

  /// Unsubscribe from single notification
  func unsubscribe(_ subscriber: AnyObject, from notification: Notification)
}
