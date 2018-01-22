//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit

class UserLocationManager: NSObject, UserLocationManagerType {

  // MARK: - Properties

  private lazy var locationManager: CLLocationManager = {
    let manager             = CLLocationManager()
    manager.delegate        = self
    manager.distanceFilter  = 5.0
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    manager.pausesLocationUpdatesAutomatically = true
    return manager
  }()

  // MARK: - LocationManager

  func getCurrent() -> Promise<CLLocationCoordinate2D> {
    return Promise { fulfill, reject in
      if let location = self.locationManager.location?.coordinate {
        fulfill(location)
      }
      else { reject(UserLocationError.unableToObtain) }
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

extension UserLocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    Managers.notification.post(.locationAuthorizationDidChange)
  }
}
