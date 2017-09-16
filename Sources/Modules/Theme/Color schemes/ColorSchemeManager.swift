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
    guard let tintColorValue = UserDefaults.standard.string(forKey: tintColorKey),
          let busColorValue  = UserDefaults.standard.string(forKey: busColorKey),
          let tramColorValue = UserDefaults.standard.string(forKey: tramColorKey),

          let tintColor = TintColor(rawValue: tintColorValue),
          let busColor  = VehicleColor(rawValue: busColorValue),
          let tramColor = VehicleColor(rawValue: tramColorValue) else {

      return ColorScheme(tint: .red, tram: .blue, bus: .red)
    }

    return ColorScheme(tint: tintColor, tram: tramColor, bus: busColor)
  }

  static func save(_ colorScheme: ColorScheme) {
    UserDefaults.standard.setValue(colorScheme.tintColor.rawValue, forKey: tintColorKey)
    UserDefaults.standard.setValue(colorScheme.busColor.rawValue,  forKey: busColorKey)
    UserDefaults.standard.setValue(colorScheme.tramColor.rawValue, forKey: tramColorKey)
  }
}
