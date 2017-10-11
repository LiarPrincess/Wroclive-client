//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit

class LocationManagerImpl: NSObject, LocationManager {

  // MARK: - Properties

  let notificationManager: NotificationManager

  private lazy var locationManager: CLLocationManager = {
    let manager             = CLLocationManager()
    manager.delegate        = self
    manager.distanceFilter  = 5.0
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    manager.pausesLocationUpdatesAutomatically = true
    return manager
  }()

  // MARK: - Init

 init(notificationManager: NotificationManager) {
    self.notificationManager = notificationManager
    super.init()
  }

  // MARK: - LocationManager

  func getUserLocation() -> Promise<CLLocationCoordinate2D> {
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
    self.notificationManager.post(.locationAuthorizationDidChange)
  }
}
