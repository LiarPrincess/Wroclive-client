// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import MapKit
import PromiseKit

public class UserLocationManager: NSObject,
                                  UserLocationManagerType,
                                  CLLocationManagerDelegate {

  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.distanceFilter = 5.0
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    manager.pausesLocationUpdatesAutomatically = true
    manager.delegate = self
    return manager
  }()

  public weak var delegate: UserLocationManagerDelegate?

  // MARK: - Get current

  public func getCurrent() -> Promise<CLLocationCoordinate2D> {
    return Promise<CLLocationCoordinate2D> { seal in
      if let location = self.locationManager.location {
        seal.fulfill(location.coordinate)
        return
      }

      let authorization = self.getAuthorizationStatus()
      switch authorization {
      case .authorized,
           .unknownValue:
        throw UserLocationError.otherError
      case .notDetermined:
        throw UserLocationError.permissionNotDetermined
      case .restricted,
           .denied:
        throw UserLocationError.permissionDenied
      }
    }
    .ensureOnMain()
  }

  // MARK: - Authorization status

  public func getAuthorizationStatus() -> UserLocationAuthorization {
    let status = CLLocationManager.authorizationStatus()
    return UserLocationAuthorization(status: status)
  }

  // MARK: - Request authorization

  public func requestWhenInUseAuthorization() {
    self.locationManager.requestWhenInUseAuthorization()
  }

  // MARK: - CLLocationManagerDelegate

  public func locationManager(_ manager: CLLocationManager,
                              didChangeAuthorization status: CLAuthorizationStatus) {
    let result = UserLocationAuthorization(status: status)
    self.delegate?.locationManager(self, didChangeAuthorization: result)
  }
}
