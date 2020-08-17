// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// swiftlint:disable object_literal

public enum ColorScheme {

  public static let tint = UIColor(red: 0.95, green: 0.14, blue: 0.14, alpha: 1.0)
  public static let tram = UIColor(red: 0.28, green: 0.49, blue: 0.80, alpha: 1.0)
  public static let bus = UIColor(red: 0.80, green: 0.12, blue: 0.12, alpha: 1.0)

  public static let userLocationPin = UIColor.systemBlue

  public static let background: UIColor = {
    if #available(iOS 13.0, *) {
      return UIColor.systemBackground
    } else {
      return UIColor.white
    }
  }()

  public static let accent: UIColor = {
    if #available(iOS 13.0, *) {
      return UIColor.opaqueSeparator
    } else {
      return UIColor(white: 0.8, alpha: 1.0)
    }
  }()

  public static let text: UIColor = {
    if #available(iOS 13.0, *) {
      return UIColor.label
    } else {
      return UIColor.black
    }
  }()

  public enum Mode {
    case light
    case dark
  }

  public static func barStyle(mode: Mode) -> UIBarStyle {
    switch mode {
    case .light: return UIBarStyle.default
    case .dark: return UIBarStyle.black
    }
  }

  @available(iOS 12.0, *)
  public static func blurStyle(for style: UIUserInterfaceStyle) -> UIBlurEffect.Style {
    switch style {
    case .light: return self.blurStyle(mode: .light)
    case .dark: return self.blurStyle(mode: .dark)
    case .unspecified: return self.blurStyle(mode: .light)
    @unknown default: return self.blurStyle(mode: .light)
    }
  }

  public static func blurStyle(mode: Mode) -> UIBlurEffect.Style {
    switch mode {
    case .light: return UIBlurEffect.Style.extraLight
    case .dark: return UIBlurEffect.Style.dark
    }
  }
}
