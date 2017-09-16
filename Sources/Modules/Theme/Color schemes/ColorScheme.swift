//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct ColorScheme {
  let background       = UIColor.white
  let backgroundAccent = UIColor(white: 0.8, alpha: 1.0)
  let text             = UIColor.black

  let configurationBackground = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1.0)

  let tintColor: TintColor
  let busColor:  VehicleColor
  let tramColor: VehicleColor

  let barStyle  = UIBarStyle.default
  let blurStyle = UIBlurEffectStyle.extraLight

  init(tint tintColor: TintColor, tram tramColor: VehicleColor, bus busColor: VehicleColor) {
    self.tintColor = tintColor
    self.busColor  = busColor
    self.tramColor = tramColor
  }
}
