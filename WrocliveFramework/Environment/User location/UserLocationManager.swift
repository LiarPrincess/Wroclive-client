// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import ReSwift
import PromiseKit

// MARK: - Helper types

extension Notification.Name {

  public static let didChangeUserlocationAuthorization =
    Notification.Name("didChangeUserlocationAuthorization")
}

public enum UserLocationError: Swift.Error, Equatable, CustomStringConvertible {

  case permissionNotDetermined
  case permissionDenied
  case otherError

  public var description: String {
    switch self {
    case .permissionNotDetermined: return "Permission not determined"
    case .permissionDenied: return "Permission denied"
    case .otherError: return "Other error"
    }
  }
}

// MARK: - Manager type

public protocol UserLocationManagerType {

  /// Returns current user location.
  func getCurrent() -> Promise<CLLocationCoordinate2D>

  /// Current authorization status.
  func getAuthorizationStatus() -> UserLocationAuthorization

  /// Request when in use authorization.
  func requestWhenInUseAuthorization()
}

// MARK: - Manager

public class UserLocationManager:
  NSObject, UserLocationManagerType, CLLocationManagerDelegate
{

  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.distanceFilter = 5.0
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    manager.pausesLocationUpdatesAutomatically = true
    manager.delegate = self
    return manager
  }()

  public func getCurrent() -> Promise<CLLocationCoordinate2D> {
    return Promise<CLLocationCoordinate2D> { seal in
      if let location = self.locationManager.location {
        seal.fulfill(location.coordinate)
        return
      }

      let authorization = self.getAuthorizationStatus()
      switch authorization {
      case .authorized:
        throw UserLocationError.otherError
      case .notDetermined:
        throw UserLocationError.permissionNotDetermined
      case .restricted,
           .denied:
        throw UserLocationError.permissionDenied
      }
    }
  }

  public func getAuthorizationStatus() -> UserLocationAuthorization {
    let status = CLLocationManager.authorizationStatus()
    return UserLocationAuthorization(status: status)
  }

  public func requestWhenInUseAuthorization() {
    self.locationManager.requestWhenInUseAuthorization()
  }

  // MARK: - CLLocationManagerDelegate

  public func locationManager(_ manager: CLLocationManager,
                              didChangeAuthorization status: CLAuthorizationStatus) {
    NotificationCenter.default.post(
      name: .didChangeUserlocationAuthorization,
      object: nil
    )
  }
}
