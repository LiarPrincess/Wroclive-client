//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct ColorScheme {

  let tint: TintColor
  let bus:  VehicleColor
  let tram: VehicleColor

  let background  = UIColor.white
  let accentLight = UIColor(white: 0.8, alpha: 1.0)
  let accentDark  = UIColor(white: 0.3, alpha: 1.0)
  let text        = UIColor.black

  let configurationBackground = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1.0)

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
