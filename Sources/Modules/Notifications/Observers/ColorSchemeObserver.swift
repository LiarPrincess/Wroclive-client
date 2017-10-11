//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

@objc protocol ColorSchemeObserver: NotificationObserver {
  func colorSchemeDidChange()
}

extension ColorSchemeObserver where Self: HasNotificationManager {
  private var notification: Notification { return .colorSchemeDidChange }

  func startObservingColorScheme() {
    self.startObserving(notification, #selector(colorSchemeDidChange))
  }

  func stopObservingColorScheme() {
    self.stopObserving(notification)
  }
}
