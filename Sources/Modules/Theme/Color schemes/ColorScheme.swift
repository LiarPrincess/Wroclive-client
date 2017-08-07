//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct ColorScheme {
  let background:       UIColor
  let backgroundAccent: UIColor

  let text:             UIColor
  let tint:             UIColor

  let bus:              UIColor
  let tram:             UIColor

  let barStyle:         UIBarStyle
  let blurStyle:        UIBlurEffectStyle
}

extension ColorScheme {

  static var light: ColorScheme {
    return ColorScheme(
      background:       UIColor.white,
      backgroundAccent: UIColor(white: 0.8, alpha: 1.0),

      text:      UIColor.black,
      tint:      UIColor(red: 1.00, green: 0.22, blue: 0.14, alpha: 1.00),

      bus:       UIColor(red: 1.00, green: 0.22, blue: 0.14, alpha: 1.00),
      tram:      UIColor(red: 0.08, green: 0.48, blue: 0.98, alpha: 1.00),

      barStyle:  UIBarStyle.default,
      blurStyle: UIBlurEffectStyle.extraLight
    )
  }

  static var dark: ColorScheme {
    return ColorScheme(
      background:       UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00),
      backgroundAccent: UIColor(white: 0.25, alpha: 1.0),

      text:      UIColor.white,
      tint:      UIColor(red:0.09, green:0.61, blue:0.78, alpha:1.00),

      bus:       UIColor(red: 0.99, green: 0.23, blue: 0.18, alpha: 1.00),
      tram:      UIColor(red: 0.08, green: 0.48, blue: 0.98, alpha: 1.00),

      barStyle:  UIBarStyle.blackTranslucent,
      blurStyle: UIBlurEffectStyle.dark
    )
  }
}
