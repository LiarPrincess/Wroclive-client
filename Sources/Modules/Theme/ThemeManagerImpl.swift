//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import Foundation

// source: https://medium.com/@abhimuralidharan/maintaining-a-colour-theme-manager-on-ios-swift-178b8a6a92
class ThemeManagerImpl: ThemeManager {

  // MARK: - Properties

  lazy fileprivate(set) var textFont: Font        = SystemFont()
  lazy fileprivate(set) var iconFont: Font        = FontAwesomeFont()
  lazy fileprivate(set) var colors:   ColorScheme = ColorSchemeManager.load()

  // Mark - Init

  init() {
    self.applyColorScheme()
  }

  // MARK: - Fonts

  func recalculateFontSizes() {
    self.textFont.recalculateSizes()
    self.iconFont.recalculateSizes()
  }

  // Mark - Color scheme

  func setColorScheme(tint tintColor: TintColor, tram tramColor: VehicleColor, bus busColor: VehicleColor) {
    self.colors = ColorScheme(tint: tintColor, tram: tramColor, bus: busColor)
    self.applyColorScheme()
    ColorSchemeManager.save(self.colors)
    Managers.notification.post(.colorSchemeDidChange)
  }

  private func applyColorScheme() {
    let tintColor = self.colors.tintColor.value

    UIApplication.shared.delegate?.window??.tintColor = tintColor

    UIWindow.appearance().tintColor = tintColor
    UIView.appearance().tintColor   = tintColor

    // Make user location pin blue
    MKAnnotationView.appearance().tintColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)

    UIToolbar.appearance().barStyle       = self.colors.barStyle
    UINavigationBar.appearance().barStyle = self.colors.barStyle
    UINavigationBar.appearance().titleTextAttributes = self.textAttributes(for : .bodyBold)
  }
}
