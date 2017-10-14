//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

@objc protocol VehicleLocationObserver: NotificationObserver {
  func vehicleLocationsDidUpdate()
}

extension VehicleLocationObserver where Self: HasNotificationManager {
  private var notification: Notification { return .vehicleLocationsDidUpdate }

  func startObservingVehicleLocations() {
    self.startObserving(notification, #selector(vehicleLocationsDidUpdate))
  }

  func stopObservingVehicleLocations() {
    self.stopObserving(notification)
  }
}
