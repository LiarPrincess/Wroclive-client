//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

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
