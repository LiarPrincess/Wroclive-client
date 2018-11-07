// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import Foundation
import MapKit

// source: https://medium.com/@abhimuralidharan/maintaining-a-colour-theme-manager-on-ios-swift-178b8a6a92
enum Theme {

  static fileprivate(set) var textFont: Font        = SystemFont()
  static fileprivate(set) var iconFont: Font        = FontAwesomeFont()
  static fileprivate(set) var colors:   ColorScheme = ColorScheme()

  static func recalculateFontSizes() {
    Theme.textFont.recalculateSizes()
    Theme.iconFont.recalculateSizes()
  }

  static func setupAppearance() {
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
