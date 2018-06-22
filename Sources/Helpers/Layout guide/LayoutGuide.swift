// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

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
