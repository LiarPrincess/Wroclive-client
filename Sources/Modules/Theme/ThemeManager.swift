//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol ThemeManager {

  // MARK: - Fonts

  var textFont: Font { get }
  var iconFont: Font { get }

  func recalculateFontSizes()

  // MARK: - Color scheme

  var colors: ColorScheme { get }

  func applyColorScheme()
  func setColorScheme(tint: TintColor, tram: VehicleColor, bus: VehicleColor)
}
