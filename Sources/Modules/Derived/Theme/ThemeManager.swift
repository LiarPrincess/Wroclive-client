//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Foundation

// source: https://medium.com/@abhimuralidharan/maintaining-a-colour-theme-manager-on-ios-swift-178b8a6a92
class ThemeManager: ThemeManagerType {

  // MARK: - Properties

  fileprivate(set) lazy var textFont: Font        = SystemFont()
  fileprivate(set) lazy var iconFont: Font        = FontAwesomeFont()
  fileprivate(set) lazy var colors:   ColorScheme = ColorSchemeManager.load(from: Managers.userDefaults)

  // MARK: - Fonts

  func recalculateFontSizes() {
    self.textFont.recalculateSizes()
    self.iconFont.recalculateSizes()
  }

  // Mark - Color scheme

  func setColorScheme(tint: TintColor, tram: VehicleColor, bus: VehicleColor) {
    self.colors = ColorScheme(tint: tint, tram: tram, bus: bus)
    self.applyColorScheme()
    ColorSchemeManager.save(self.colors, to: Managers.userDefaults)
    Managers.notification.post(.colorSchemeDidChange)
  }
}
