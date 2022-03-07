// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import MapKit

public enum UserLocationAuthorization: CustomStringConvertible {

  /// User has not yet made a choice with regards to this application
  case notDetermined
  /// User has authorized this application to use location services.
  ///
  /// This case merges `authorizedAlways` and `authorizedWhenInUse`.
  case authorized
  /// This application is not authorized to use location services.
  /// Due to active restrictions on location services, the user cannot change
  /// this status, and may not have personally denied authorization
  case restricted
  /// User has explicitly denied authorization for this application,
  /// or location services are disabled in Settings.
  case denied
  /// Value added in new iOS version.
  case unknownValue

  public var description: String {
    switch self {
    case .notDetermined: return "Not determined"
    case .authorized: return "Authorized"
    case .restricted: return "Restricted"
    case .denied: return "Denied"
    case .unknownValue: return "Unknown value"
    }
  }

  public init(status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      self = .notDetermined
    case .authorizedAlways,
         .authorizedWhenInUse:
      self = .authorized
    case .denied:
      self = .denied
    case .restricted:
      self = .restricted
    @unknown default:
      self = .unknownValue
    }
  }
}
