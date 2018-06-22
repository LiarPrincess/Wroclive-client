// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

class VehicleAnnotationPinView: UIView {

  // MARK: - Properties

  var angle: CGFloat = 0.0 {
    didSet { self.transform = CGAffineTransform(rotationAngle: self.angle.rad) }
  }

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.allowsEdgeAntialiasing = true
    self.backgroundColor              = UIColor.clear
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Draw

  override func draw(_ rect: CGRect) {
    let color    = self.tintColor ?? UIColor.black
    let resizing = StyleKit.ResizingBehavior.aspectFit
    StyleKit.drawVehiclePin(frame: self.bounds, color: color, resizing: resizing)
  }
}
