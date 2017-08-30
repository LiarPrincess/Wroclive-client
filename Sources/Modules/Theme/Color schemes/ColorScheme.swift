//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct ColorScheme {
  let background       = UIColor.white
  let backgroundAccent = UIColor(white: 0.8, alpha: 1.0)
  let text             = UIColor.black

  let tintColor: TintColor
  let busColor:  VehicleColor
  let tramColor: VehicleColor

  let barStyle  = UIBarStyle.default
  let blurStyle = UIBlurEffectStyle.extraLight

  init(tint tintColor: TintColor, bus busColor: VehicleColor, tram tramColor: VehicleColor) {
    self.tintColor = tintColor
    self.busColor  = busColor
    self.tramColor = tramColor
  }
}
