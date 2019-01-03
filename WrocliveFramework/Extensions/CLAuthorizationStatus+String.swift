// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import MapKit

extension CLAuthorizationStatus: CustomStringConvertible {
  public var description: String {
    switch self {
    case .denied: return "denied"
    case .restricted: return "restricted"
    case .notDetermined: return "notDetermined"
    case .authorizedAlways: return "authorizedAlways"
    case .authorizedWhenInUse: return "authorizedWhenInUse"
    }
  }
}
