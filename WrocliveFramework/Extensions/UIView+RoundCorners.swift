// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

extension UIView {
  public func roundTopCorners(radius: CGFloat) {
    self.roundCorners([.topLeft, .topRight], radius: radius)
  }

  public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let cornerRadii = CGSize(width: radius, height: radius)
    let maskPath    = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)

    let maskLayer   = CAShapeLayer()
    maskLayer.frame = self.bounds
    maskLayer.path  = maskPath.cgPath

    self.layer.mask = maskLayer
  }
}
