//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum VehicleColor: String {
  case red
  case blue
  case green
  case orange
  case pink
  case black

  var value: UIColor {
    switch self {
    case .red:    return UIColor(hue: 0.00, saturation: 0.85, brightness: 0.80, alpha: 1.0)
    case .blue:   return UIColor(hue: 0.60, saturation: 0.65, brightness: 0.80, alpha: 1.0)
    case .green:  return UIColor(hue: 0.25, saturation: 0.65, brightness: 0.70, alpha: 1.0)
    case .orange: return UIColor(hue: 0.08, saturation: 0.90, brightness: 1.00, alpha: 1.0)
    case .pink:   return UIColor(hue: 0.95, saturation: 0.74, brightness: 1.00, alpha: 1.0)
    case .black:  return UIColor(white: 0.0, alpha: 1.0)
    }
  }

  static var allValues: [VehicleColor] {
    return [.red, .blue, .green, .orange, .pink, .black]
  }
}
