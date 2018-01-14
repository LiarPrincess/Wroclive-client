//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class VehiclePinView: UIView {

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
