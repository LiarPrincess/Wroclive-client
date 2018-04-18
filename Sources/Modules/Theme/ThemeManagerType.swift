//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import Foundation

protocol ThemeManagerType {

  // MARK: - Fonts

  var textFont: Font { get }
  var iconFont: Font { get }

  func recalculateFontSizes()

  // MARK: - Color scheme

  var colors: ColorScheme { get }

  func applyColorScheme()
}

extension ThemeManagerType {
  func applyColorScheme() {
    let tintColor = self.colors.tint

    UIApplication.shared.delegate?.window??.tintColor = tintColor

    UIWindow.appearance().tintColor = tintColor
    UIView.appearance().tintColor   = tintColor

    // Make user location pin blue
    MKAnnotationView.appearance().tintColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)

    UIToolbar.appearance().barStyle       = self.colors.barStyle
    UINavigationBar.appearance().barStyle = self.colors.barStyle
    UINavigationBar.appearance().titleTextAttributes = TextAttributes(style: .bodyBold).value
  }
}
