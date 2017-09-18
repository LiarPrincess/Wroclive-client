//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

enum NotificationData {
  case colorSchemeDidChange
  case vehicleLocationsDidUpdate
  case locationAuthorizationDidChange

  var notification: Notification {
    switch self {
    case .colorSchemeDidChange:           return Notification.colorSchemeDidChange
    case .vehicleLocationsDidUpdate:      return Notification.vehicleLocationsDidUpdate
    case .locationAuthorizationDidChange: return Notification.locationAuthorizationDidChange
    }
  }

  var name: Foundation.Notification.Name { return self.notification.name }
}
