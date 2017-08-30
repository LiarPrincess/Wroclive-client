//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

// https://developer.apple.com/ios/human-interface-guidelines/visual-design/color/
enum TintColor: String {
  case red
  case blue
  case green
  case orange
  case pink
  case black

  var value: UIColor {
    switch self {
    case .red:    return UIColor(red: 1.00, green: 0.22, blue: 0.14, alpha: 1.00)
    case .blue:   return UIColor(red: 0.00, green: 0.50, blue: 1.00, alpha: 1.00)
    case .green:  return UIColor(red: 0.12, green: 0.66, blue: 0.15, alpha: 1.00)
    case .orange: return UIColor(red: 1.00, green: 0.50, blue: 0.15, alpha: 1.00)
    case .pink:   return UIColor(red: 1.00, green: 0.00, blue: 0.40, alpha: 1.00)
    case .black:  return UIColor(white: 0.0, alpha: 1.0)
    }
  }
}

enum VehicleColor: String {
  case red
  case blue
  case green
  case pink
  case black

  var value: UIColor {
    switch self {
    case .red:   return UIColor(red: 0.80, green: 0.14, blue: 0.11, alpha: 1.00)
    case .blue:  return UIColor(red: 0.29, green: 0.52, blue: 0.82, alpha: 1.00)
    case .green: return UIColor(red: 0.46, green: 0.70, blue: 0.24, alpha: 1.00)
    case .pink:  return UIColor(red: 0.84, green: 0.44, blue: 0.72, alpha: 1.00)
    case .black: return UIColor(white: 0.0, alpha: 1.0)
    }
  }
}
