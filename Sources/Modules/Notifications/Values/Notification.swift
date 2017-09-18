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

  var name: Foundation.Notification.Name {
    switch self {
    case .colorSchemeDidChange:           return Notification.name("pl.kekapp.colorSchemeDidChange")
    case .vehicleLocationsDidUpdate:      return Notification.name("pl.kekapp.vehicleLocationsDidUpdate")
    case .locationAuthorizationDidChange: return Notification.name("pl.kekapp.locationAuthorizationDidChange")
    case .contentSizeCategoryDidChange:   return Foundation.Notification.Name.UIContentSizeCategoryDidChange
    }
  }

  private static func name(_ value: String) -> Foundation.Notification.Name {
    return Foundation.Notification.Name(rawValue: value)
  }
}
