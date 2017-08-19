//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class InAppPurchasePresentationViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let color0 = UIColor(red: 0.13, green: 0.65, blue: 0.85, alpha: 1.00)
    let color1 = UIColor(red: 0.40, green: 0.30, blue: 0.60, alpha: 1.00)

    let gradientLayer = CAGradientLayer()
    gradientLayer.frame     = self.view.bounds
    gradientLayer.colors    = [color0.cgColor, color1.cgColor]
    gradientLayer.locations = [0.00, 0.75]
    self.view.layer.addSublayer(gradientLayer)
  }

}
