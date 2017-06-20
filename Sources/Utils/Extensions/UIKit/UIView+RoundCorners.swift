//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

extension UIView {

  func roundTopCorners(radius: CGFloat) {
    self.roundCorners([UIRectCorner.topLeft, UIRectCorner.topRight], radius: radius)
  }

  func roundBottomCorners(radius: CGFloat) {
    self.roundCorners([UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius: radius)
  }

  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let cornerRadii = CGSize(width: radius, height: radius)
    let maskPath    = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)

    let maskLayer   = CAShapeLayer()
    maskLayer.frame = self.bounds
    maskLayer.path  = maskPath.cgPath

    self.layer.mask = maskLayer
  }

}
