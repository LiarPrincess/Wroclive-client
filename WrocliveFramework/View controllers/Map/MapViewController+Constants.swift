// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit

// swiftlint:disable nesting

extension MapViewController {

  public enum Constants {

    /// In meters
    public static let minDistanceToUpdateCenter = CLLocationDistance(10.0)

    public enum Pin {
      public static let imageSize = CGSize(width: 50.0, height: 50.0)
      public static let animationDuration = TimeInterval(1.5)
    }

    public enum Default {
      public static let center = CLLocationCoordinate2D(latitude: 51.109_524,
                                                        longitude: 17.032_564)
      public static let zoom = CLLocationDistance(3_500.0) // m
    }
  }
}
