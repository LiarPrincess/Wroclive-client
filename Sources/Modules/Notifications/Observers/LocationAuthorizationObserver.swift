//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

@objc protocol LocationAuthorizationObserver: NotificationObserver {
  func locationAuthorizationDidChange()
}

extension LocationAuthorizationObserver {
  private var notification: Notification { return .locationAuthorizationDidChange }

  func startObservingLocationAuthorization() {
    self.startObserving(notification, #selector(locationAuthorizationDidChange))
  }

  func stopObservingLocationAuthorization() {
    self.stopObserving(notification)
  }
}
