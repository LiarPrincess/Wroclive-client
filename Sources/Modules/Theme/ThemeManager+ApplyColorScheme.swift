//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import Foundation

extension ThemeManager {
  func applyColorScheme() {
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