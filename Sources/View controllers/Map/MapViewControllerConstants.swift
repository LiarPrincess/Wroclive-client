//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit

struct MapViewControllerConstants {

  struct Pin {
    static let imageSize:              CGSize       = CGSize(width: 28.0, height: 28.0)
    static let minAngleChangeToRedraw: CGFloat      = 3.0
    static let animationDuration:      TimeInterval = 1.5
  }

  struct Defaults {
    static let cityCenter = CLLocationCoordinate2D(latitude: 51.109_524, longitude: 17.032_564)
    static let cityRadius = CLLocationDistance(25_000.0) // m
    static let regionSize = CLLocationDistance( 2_500.0) // m

    static let minDegChangeToUpdate: CLLocationDegrees = 0.01
  }
}
