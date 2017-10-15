//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

@objc protocol ContentSizeCategoryObserver: NotificationObserver {
  func contentSizeCategoryDidChange()
}

extension ContentSizeCategoryObserver where Self: HasNotificationManager {
  private var notification: Notification { return .contentSizeCategoryDidChange }

  func startObservingContentSizeCategory() {
    self.startObserving(notification, #selector(contentSizeCategoryDidChange))
  }

  func stopObservingContentSizeCategory() {
    self.stopObserving(notification)
  }
}
