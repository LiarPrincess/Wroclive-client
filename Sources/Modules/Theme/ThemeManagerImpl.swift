//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import Foundation

// source: https://medium.com/@abhimuralidharan/maintaining-a-colour-theme-manager-on-ios-swift-178b8a6a92
class ThemeManagerImpl: ThemeManager, HasNotificationManager {

  // MARK: - Properties

  let notification: NotificationManager

  fileprivate(set) var textFont: Font = SystemFont()
  fileprivate(set) var iconFont: Font = FontAwesomeFont()

  fileprivate(set) var colorScheme: ColorScheme

  // Mark - Init

  init(notification: NotificationManager) {
    self.notification = notification
    self.colorScheme  = ColorSchemeManager.load()

    self.startObservingContentSizeCategory()
    self.applyColorScheme()
  }

  deinit {
    self.stopObservingContentSizeCategory()
  }

  // Mark - Color scheme

  func setColorScheme(tint tintColor: TintColor, tram tramColor: VehicleColor, bus busColor: VehicleColor) {
    self.colorScheme = ColorScheme(tint: tintColor, tram: tramColor, bus: busColor)
    self.applyColorScheme()
    ColorSchemeManager.save(self.colorScheme)
    self.notification.post(.colorSchemeDidChange)
  }

  private func applyColorScheme() {
    let tintColor = self.colorScheme.tintColor.value

    UIApplication.shared.delegate?.window??.tintColor = tintColor

    UIWindow.appearance().tintColor = tintColor
    UIView.appearance().tintColor   = tintColor

    // Make user location pin blue
    MKAnnotationView.appearance().tintColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)

    UIToolbar.appearance().barStyle       = self.colorScheme.barStyle
    UINavigationBar.appearance().barStyle = self.colorScheme.barStyle
    UINavigationBar.appearance().titleTextAttributes = self.textAttributes(for : .bodyBold)
  }
}

// MARK: - Notifications

extension ThemeManagerImpl: ContentSizeCategoryObserver {
  func contentSizeCategoryDidChange() {
    self.textFont.recalculateSizes()
    self.iconFont.recalculateSizes()
  }
}
