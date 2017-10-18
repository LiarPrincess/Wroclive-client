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
  func setColorScheme(tint tintColor: TintColor, tram tramColor: VehicleColor, bus busColor: VehicleColor)
}
