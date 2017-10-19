//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class ColorSchemeManager {

  private static let tintColorKey = "Theme_tintColor"
  private static let busColorKey  = "Theme_busColor"
  private static let tramColorKey = "Theme_tramColor"

  static func load() -> ColorScheme {
    guard let tintColorValue = Managers.userDefaults.string(forKey: tintColorKey),
          let busColorValue  = Managers.userDefaults.string(forKey: busColorKey),
          let tramColorValue = Managers.userDefaults.string(forKey: tramColorKey),

          let tintColor = TintColor(rawValue: tintColorValue),
          let busColor  = VehicleColor(rawValue: busColorValue),
          let tramColor = VehicleColor(rawValue: tramColorValue)
      else { return ColorScheme.default }

    return ColorScheme(tint: tintColor, tram: tramColor, bus: busColor)
  }

  static func save(_ colorScheme: ColorScheme) {
    Managers.userDefaults.set(colorScheme.tintColor.rawValue, forKey: tintColorKey)
    Managers.userDefaults.set(colorScheme.busColor.rawValue,  forKey: busColorKey)
    Managers.userDefaults.set(colorScheme.tramColor.rawValue, forKey: tramColorKey)
  }
}
