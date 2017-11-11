//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class ColorSchemeManager {

  static func load() -> ColorScheme {
    guard let tintColorString = Managers.userDefaults.getString(.preferredTintColor),
          let tramColorString = Managers.userDefaults.getString(.preferredTramColor),
          let busColorString  = Managers.userDefaults.getString(.preferredBusColor),

          let tintColor = TintColor(rawValue: tintColorString),
          let tramColor = VehicleColor(rawValue: tramColorString),
          let busColor  = VehicleColor(rawValue: busColorString)
      else { return ColorScheme.default }

    return ColorScheme(tint: tintColor, tram: tramColor, bus: busColor)
  }

  static func save(_ colorScheme: ColorScheme) {
    Managers.userDefaults.setString(.preferredTintColor, to: colorScheme.tint.rawValue)
    Managers.userDefaults.setString(.preferredTramColor, to: colorScheme.tram.rawValue)
    Managers.userDefaults.setString(.preferredBusColor,  to: colorScheme.bus.rawValue)
  }
}
