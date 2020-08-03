// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import PromiseKit

// MARK: - Helper types

public enum UserLocationAuthorization {
  /// User has not yet made a choice with regards to this application
  case notDetermined
  /// This application is not authorized to use location services.
  /// Due to active restrictions on location services, the user cannot change
  /// this status, and may not have personally denied authorization
  case restricted
  /// User has explicitly denied authorization for this application,
  /// or location services are disabled in Settings.
  case denied
  /// User has authorized this application to use location services.
  ///
  /// This case merges `authorizedAlways` and `authorizedWhenInUse`.
  case authorized

  public var isNotDetermined: Bool {
    switch self {
    case .notDetermined:
      return true
    case .authorized, .restricted, .denied:
      return false
    }
  }

  public var isAuthorized: Bool {
    switch self {
    case .authorized:
      return true
    case .notDetermined, .restricted, .denied:
      return false
    }
  }
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

public struct UserLocationManager: UserLocationManagerType {

  private var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.distanceFilter  = 5.0
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    manager.pausesLocationUpdatesAutomatically = true
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

  // TODO: Remove this and use AppState?
  public func getAuthorizationStatus() -> UserLocationAuthorization {
    let result = CLLocationManager.authorizationStatus()

    switch result {
    case .notDetermined:
      return .notDetermined
    case .denied:
      return .denied
    case .authorizedAlways,
         .authorizedWhenInUse:
      return .authorized
    case .restricted:
      return .restricted
    @unknown default:
      // Not sure what to do, we will just assume best case.
      return .authorized
    }
  }

  public func requestWhenInUseAuthorization() {
    self.locationManager.requestWhenInUseAuthorization()
  }
}
