// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// swiftlint:disable object_literal

public struct ColorScheme {

  public let tint = UIColor(hue: 0.00, saturation: 0.85, brightness: 0.95, alpha: 1.0)
  public let tram = UIColor(hue: 0.60, saturation: 0.65, brightness: 0.80, alpha: 1.0)
  public let bus = UIColor(hue: 0.00, saturation: 0.85, brightness: 0.80, alpha: 1.0)

  public let userLocationPin = UIColor.systemBlue

  public let background: UIColor = {
    if #available(iOS 13.0, *) {
      return UIColor.systemBackground
    } else {
      return UIColor.white
    }
  }()

  public let accent: UIColor = {
    if #available(iOS 13.0, *) {
      return UIColor.opaqueSeparator
    } else {
      return UIColor(white: 0.8, alpha: 1.0)
    }
  }()

  public let text: UIColor = {
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

  public func barStyle(mode: Mode) -> UIBarStyle {
    switch mode {
    case .light: return UIBarStyle.default
    case .dark: return UIBarStyle.black
    }
  }

  @available(iOS 12.0, *)
  public func blurStyle(for style: UIUserInterfaceStyle) -> UIBlurEffect.Style {
    switch style {
    case .light: return self.blurStyle(mode: .light)
    case .dark: return self.blurStyle(mode: .dark)
    case .unspecified: return self.blurStyle(mode: .light)
    @unknown default: return self.blurStyle(mode: .light)
    }
  }

  public func blurStyle(mode: Mode) -> UIBlurEffect.Style {
    switch mode {
    case .light: return UIBlurEffect.Style.extraLight
    case .dark: return UIBlurEffect.Style.dark
    }
  }
}
