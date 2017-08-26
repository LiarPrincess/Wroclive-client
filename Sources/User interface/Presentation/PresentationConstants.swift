//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct PresentationConstants {
  struct Colors {
    static let textPrimary   = UIColor.white
    static let textSecondary = UIColor(white: 0.8, alpha: 1.0)

    static let buttonBackground = UIColor(red: 0.00, green: 0.59, blue: 0.95, alpha: 1.00)

    struct Gradient {
      static let colors: [UIColor] = [
        UIColor(red: 0.18, green: 0.85, blue: 0.80, alpha: 1.00),
        UIColor(red: 0.13, green: 0.65, blue: 0.85, alpha: 1.00),
        UIColor(red: 0.40, green: 0.30, blue: 0.60, alpha: 1.00)
      ]

      static let locations: [NSNumber] = [0.0, 0.35, 0.9]
    }
  }
}
