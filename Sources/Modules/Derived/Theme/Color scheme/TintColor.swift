//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum TintColor: String {
  case red
  case blue
  case green
  case orange
  case pink
  case black

  var value: UIColor {
    switch self {
    case .red:    return UIColor(hue: 0.00, saturation: 0.85, brightness: 0.95, alpha: 1.0)
    case .blue:   return UIColor(hue: 0.60, saturation: 0.90, brightness: 1.00, alpha: 1.0)
    case .green:  return UIColor(hue: 0.35, saturation: 0.80, brightness: 0.66, alpha: 1.0)
    case .orange: return UIColor(hue: 0.06, saturation: 0.95, brightness: 1.00, alpha: 1.0)
    case .pink:   return UIColor(hue: 0.95, saturation: 0.87, brightness: 0.95, alpha: 1.0)
    case .black:  return UIColor(white: 0.0, alpha: 1.0)
    }
  }

  static var allValues: [TintColor] {
    return [.red, .blue, .green, .orange, .pink, .black]
  }
}
