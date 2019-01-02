// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import MapKit

extension CLLocationCoordinate2D {
  func distance(from location: CLLocationCoordinate2D) -> CLLocationDistance {
    let lhs = CLLocation(coordinate: self)
    let rhs = CLLocation(coordinate: location)
    return lhs.distance(from: rhs)
  }
}
