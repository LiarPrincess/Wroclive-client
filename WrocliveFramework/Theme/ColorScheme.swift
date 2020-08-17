// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// swiftlint:disable object_literal

public struct ColorScheme {

  public let tint = UIColor(hue: 0.00, saturation: 0.85, brightness: 0.95, alpha: 1.0)
  public let tram = UIColor(hue: 0.60, saturation: 0.65, brightness: 0.80, alpha: 1.0)
  public let bus = UIColor(hue: 0.00, saturation: 0.85, brightness: 0.80, alpha: 1.0)

  public let background: UIColor = {
    if #available(iOS 13.0, *) {
      return UIColor.systemBackground
    } else {
      return UIColor.white
    }
  }()

  public let accent: UIColor = {
    if #available(iOS 13.0, *) {
      return UIColor.separator
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

  public let barStyle = UIBarStyle.default
  public let blurStyle = UIBlurEffect.Style.extraLight

  public let lightBarStyle = UIBarStyle.default
  public let darkBarStyle = UIBarStyle.black

  public let lightBlurStyle = UIBlurEffect.Style.extraLight
  public let darkBlurStyle = UIBlurEffect.Style.dark
}
