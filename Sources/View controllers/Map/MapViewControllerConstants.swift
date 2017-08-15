//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit

struct MapViewControllerConstants {

  struct MapView {
    static let mapType           = MKMapType.standard
    static let showsBuildings    = true
    static let showsCompass      = true
    static let showsScale        = false
    static let showsTraffic      = false
    static let showsUserLocation = true
  }

  struct Layout {
    static let pinImageSize = CGSize(width: 28.0, height: 28.0)
  }

  static let minAngleChangeToRedraw: CGFloat = 3.0
}
