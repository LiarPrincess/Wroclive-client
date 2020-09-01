// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// swiftlint:disable object_literal
// swiftlint:disable discouraged_object_literal
// swiftformat:disable numberFormatting

public enum ColorScheme {

  public static let tint = #colorLiteral(red: 0.9490196078, green: 0.1411764706, blue: 0.1411764706, alpha: 1)

  public static let tram = #colorLiteral(red: 0.2784313725, green: 0.5019607843, blue: 0.8, alpha: 1)
  public static let busRegular = #colorLiteral(red: 0.8, green: 0.1215686275, blue: 0.1215686275, alpha: 1)
  public static let busNight = #colorLiteral(red: 0.6078431373, green: 0.1607843137, blue: 0.7137254902, alpha: 1)
  public static let busExpress = #colorLiteral(red: 0.968627451, green: 0.7607843137, blue: 0.2431372549, alpha: 1)
  public static let busSuburban = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
  public static let busOther = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)

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
