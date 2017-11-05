//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct PresentationColorScheme {
  let textPrimary   = UIColor.white
  let textSecondary = UIColor(white: 0.9, alpha: 1.0)

  let button = UIColor(red: 0.00, green: 0.59, blue: 0.95, alpha: 1.00)

  let gradient: [UIColor] = [
    UIColor(red: 0.18, green: 0.85, blue: 0.80, alpha: 1.00),
    UIColor(red: 0.13, green: 0.65, blue: 0.85, alpha: 1.00),
    UIColor(red: 0.40, green: 0.30, blue: 0.60, alpha: 1.00)
  ]

  let gradientLocations: [Float] = [0.0, 0.35, 0.9]
}

struct ColorScheme {

  let tint: TintColor
  let bus:  VehicleColor
  let tram: VehicleColor

  let background  = UIColor.white
  let accentLight = UIColor(white: 0.8, alpha: 1.0)
  let accentDark  = UIColor(white: 0.3, alpha: 1.0)
  let text        = UIColor.black

  let configurationBackground = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1.0)

  let presentation = PresentationColorScheme()

  let barStyle  = UIBarStyle.default
  let blurStyle = UIBlurEffectStyle.extraLight

  // MARK: - Init

  init(tint: TintColor, tram: VehicleColor, bus: VehicleColor) {
    self.tint = tint
    self.bus  = bus
    self.tram = tram
  }

  static var `default`: ColorScheme {
    return ColorScheme(tint: .red, tram: .blue, bus: .red)
  }
}
