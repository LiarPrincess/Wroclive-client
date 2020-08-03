// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import MapKit

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

  public init(status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      self = .notDetermined
    case .denied:
      self = .denied
    case .authorizedAlways,
         .authorizedWhenInUse:
      self = .authorized
    case .restricted:
      self = .restricted
    @unknown default:
      // Not sure what to do, we will just assume best case.
      self = .authorized
    }
  }

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
