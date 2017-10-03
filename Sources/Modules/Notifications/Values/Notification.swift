//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

enum Notification {
  case colorSchemeDidChange
  case vehicleLocationsDidUpdate
  case locationAuthorizationDidChange
  case contentSizeCategoryDidChange
  case applicationDidBecomeActive
  case applicationWillResignActive

  var name: Foundation.Notification.Name {
    switch self {
    case .colorSchemeDidChange:           return Notification.name("pl.kekapp.colorSchemeDidChange")
    case .vehicleLocationsDidUpdate:      return Notification.name("pl.kekapp.vehicleLocationsDidUpdate")
    case .locationAuthorizationDidChange: return Notification.name("pl.kekapp.locationAuthorizationDidChange")
    case .contentSizeCategoryDidChange:   return Foundation.Notification.Name.UIContentSizeCategoryDidChange
    case .applicationDidBecomeActive:     return Foundation.Notification.Name.UIApplicationDidBecomeActive
    case .applicationWillResignActive:    return Foundation.Notification.Name.UIApplicationWillResignActive
    }
  }

  private static func name(_ value: String) -> Foundation.Notification.Name {
    return Foundation.Notification.Name(rawValue: value)
  }
}
