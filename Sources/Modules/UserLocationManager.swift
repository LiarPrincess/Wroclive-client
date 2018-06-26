// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import RxSwift
import RxCoreLocation

class UserLocationManager: NSObject, UserLocationManagerType {

  // MARK: - Properties

  private lazy var locationManager: CLLocationManager = {
    let manager             = CLLocationManager()
    manager.distanceFilter  = 5.0
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    manager.pausesLocationUpdatesAutomatically = true
    return manager
  }()

  // MARK: - UserLocationManagerType

  var currentLocation: Single<CLLocationCoordinate2D> {
    return self.locationManager.rx.location
      .map { location in
        switch location {
        case .none:
          let authorization = CLLocationManager.authorizationStatus()
          switch authorization {
          case .authorizedAlways,
               .authorizedWhenInUse: throw UserLocationError.generalError
          case .notDetermined: throw UserLocationError.permissionNotDetermined
          case .restricted,
               .denied: throw UserLocationError.permissionDenied
          }
        case let .some(location): return location.coordinate
        }
      }
      .asSingle()
  }

  var authorization: Observable<CLAuthorizationStatus> {
    return self.locationManager.rx.didChangeAuthorization
      .map { $0.status }
  }

  func requestWhenInUseAuthorization() {
    self.locationManager.requestWhenInUseAuthorization()
  }
}
