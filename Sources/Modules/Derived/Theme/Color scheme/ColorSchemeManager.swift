//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class ColorSchemeManager {

  static func load(from userDefaults: UserDefaultsManager) -> ColorScheme {
    guard let tintColorString = userDefaults.getString(.preferredTintColor),
          let tramColorString = userDefaults.getString(.preferredTramColor),
          let busColorString  = userDefaults.getString(.preferredBusColor),

          let tintColor = TintColor(rawValue: tintColorString),
          let tramColor = VehicleColor(rawValue: tramColorString),
          let busColor  = VehicleColor(rawValue: busColorString)
      else { return ColorScheme.default }

    return ColorScheme(tint: tintColor, tram: tramColor, bus: busColor)
  }

  static func save(_ colorScheme: ColorScheme, to userDefaults: UserDefaultsManager) {
    userDefaults.setString(.preferredTintColor, to: colorScheme.tint.rawValue)
    userDefaults.setString(.preferredTramColor, to: colorScheme.tram.rawValue)
    userDefaults.setString(.preferredBusColor,  to: colorScheme.bus.rawValue)
  }
}
