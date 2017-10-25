//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Foundation

// source: https://medium.com/@abhimuralidharan/maintaining-a-colour-theme-manager-on-ios-swift-178b8a6a92
class ThemeManagerImpl: ThemeManager {

  // MARK: - Properties

  lazy fileprivate(set) var textFont: Font        = SystemFont()
  lazy fileprivate(set) var iconFont: Font        = FontAwesomeFont()
  lazy fileprivate(set) var colors:   ColorScheme = ColorSchemeManager.load()

  // MARK: - Fonts

  func recalculateFontSizes() {
    self.textFont.recalculateSizes()
    self.iconFont.recalculateSizes()
  }

  // Mark - Color scheme

  func setColorScheme(tint: TintColor, tram: VehicleColor, bus: VehicleColor) {
    self.colors = ColorScheme(tint: tint, tram: tram, bus: bus)
    self.applyColorScheme()
    ColorSchemeManager.save(self.colors)
    Managers.notification.post(.colorSchemeDidChange)
  }
}
