//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit

class LocationManagerImpl: NSObject, LocationManager, HasNotificationManager {

  // MARK: - Properties

  let notification: NotificationManager

  private lazy var locationManager: CLLocationManager = {
    let manager             = CLLocationManager()
    manager.delegate        = self
    manager.distanceFilter  = 5.0
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    manager.pausesLocationUpdatesAutomatically = true
    return manager
  }()

  // MARK: - Init

 init(notification: NotificationManager) {
    self.notification = notification
    super.init()
  }

  // MARK: - LocationManager

  func getCurrent() -> Promise<CLLocationCoordinate2D> {
    return Promise { fulfill, reject in
      if let location = self.locationManager.location?.coordinate {
        fulfill(location)
      }
      else { reject(LocationError.unableToObtainUserLocation) }
    }
  }

  var authorization: CLAuthorizationStatus {
    return CLLocationManager.authorizationStatus()
  }

  func requestAuthorization() {
    self.locationManager.requestWhenInUseAuthorization()
  }
}

// MARK: - CLLocationManagerDelegate

extension LocationManagerImpl: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    self.notification.post(.locationAuthorizationDidChange)
  }
}
