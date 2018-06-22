// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit

enum MapViewControllerConstants {

  enum Pin {
    static let imageSize:              CGSize       = CGSize(width: 50.0, height: 50.0)
    static let minAngleChangeToRedraw: CGFloat      = 3.0
    static let animationDuration:      TimeInterval = 1.5
  }

  struct Defaults {
    static let location = CLLocationCoordinate2D(latitude: 51.109_524, longitude: 17.032_564)
    static let zoom     = CLLocationDistance(3_500.0) // m
  }
}
