// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import MapKit

// We cannot add 'CustomStringConvertible' as we don't own 'CLAuthorizationStatus'
extension CLAuthorizationStatus {

  public var string: String {
    switch self {
    case .denied: return "denied"
    case .restricted: return "restricted"
    case .notDetermined: return "Not determined"
    case .authorizedAlways: return "Authorized always"
    case .authorizedWhenInUse: return "AuthorizedWhen in use"
    @unknown default: return "Unknown"
    }
  }
}

extension CLLocation {

  public convenience init(coordinate: CLLocationCoordinate2D) {
    self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }
}

extension CLLocationCoordinate2D {

  public func distance(from location: CLLocationCoordinate2D) -> CLLocationDistance {
    let lhs = CLLocation(coordinate: self)
    let rhs = CLLocation(coordinate: location)
    return lhs.distance(from: rhs)
  }
}
