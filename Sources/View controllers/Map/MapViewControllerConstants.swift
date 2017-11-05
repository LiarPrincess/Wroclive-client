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
    static let cityCenter = CLLocationCoordinate2D(latitude: 51.109524, longitude: 17.032564)
    static let cityRadius = CLLocationDistance(25.0 * 1000.0) // m
    static let regionSize = CLLocationDistance( 2.5 * 1000.0) // m

    static let minDegChangeToUpdate: CLLocationDegrees = 0.01
  }
}
