// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import Foundation
import MapKit

// source: https://medium.com/@abhimuralidharan/maintaining-a-colour-theme-manager-on-ios-swift-178b8a6a92
public enum Theme {

  public fileprivate(set) static var textFont: FontPreset  = SystemFont()
  public fileprivate(set) static var iconFont: FontPreset  = FontAwesome()
  public fileprivate(set) static var colors:   ColorScheme = ColorScheme()

  public static func recalculateFontSizes() {
    Theme.textFont.recalculateSizes()
    Theme.iconFont.recalculateSizes()
  }

  public static func setupAppearance() {
    let tintColor = Theme.colors.tint
    let barStyle  = Theme.colors.barStyle

    UIApplication.shared.delegate?.window??.tintColor = tintColor

    UIWindow.appearance().tintColor = tintColor
    UIView.appearance().tintColor   = tintColor

    // Make user location pin blue
    MKAnnotationView.appearance().tintColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)

    UIToolbar.appearance().barStyle       = barStyle
    UINavigationBar.appearance().barStyle = barStyle
    UINavigationBar.appearance().titleTextAttributes = TextAttributes(style: .bodyBold).value
  }
}
