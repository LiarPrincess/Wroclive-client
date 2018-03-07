//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

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

  var current: Observable<CLLocationCoordinate2D> {
    return self.locationManager.rx.status
      .flatMapLatest { authorization -> Observable<CLLocation?> in
        switch authorization {
        case .authorizedAlways,
             .authorizedWhenInUse: return self.locationManager.rx.location
        case .notDetermined:       throw UserLocationError.permissionNotDetermined
        case .restricted,
             .denied:              throw UserLocationError.permissionDenied
        }
      }
      .map { location -> CLLocationCoordinate2D in
        switch location?.coordinate {
        case let .some(coordinate): return coordinate
        case .none:                 throw UserLocationError.generalError
        }
      }
  }

  var authorization: Observable<CLAuthorizationStatus> {
    return self.locationManager.rx.didChangeAuthorization
      .map { $0.status }
  }

  func requestWhenInUseAuthorization() {
    self.locationManager.requestWhenInUseAuthorization()
  }
}
