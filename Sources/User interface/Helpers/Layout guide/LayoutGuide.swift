//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

// source: https://github.com/RoelofRoos/MKMapView-Legal-Notice-and-Compass-Placement

final class LayoutGuide: NSObject, UILayoutSupport {
  let length: CGFloat

  init(length: CGFloat) {
    self.length = length
  }

  @available(iOS 9.0, *)
  var topAnchor: NSLayoutYAxisAnchor {
    return NSLayoutYAxisAnchor()
  }

  @available(iOS 9.0, *)
  var bottomAnchor: NSLayoutYAxisAnchor {
    return NSLayoutYAxisAnchor()
  }

  @available(iOS 9.0, *)
  var heightAnchor: NSLayoutDimension {
    return NSLayoutDimension()
  }
}
