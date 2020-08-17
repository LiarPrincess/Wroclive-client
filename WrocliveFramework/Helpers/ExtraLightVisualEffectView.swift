// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

/// Basically a standard `UIVisualEffectView`, but it will use colors from `ColorScheme`.
public final class ExtraLightVisualEffectView: UIVisualEffectView {

  public init() {
    super.init(effect: nil)

    // Set initial effect
    self.traitCollectionDidChange(nil)
  }

  // swiftlint:disable:next unavailable_function
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if #available(iOS 12.0, *) {
      let newStyle = self.traitCollection.userInterfaceStyle
      let oldStyle = previousTraitCollection?.userInterfaceStyle

      guard newStyle != oldStyle else {
        return
      }

      switch newStyle {
      case .light:
        self.effect = Self.createEffect(type: .light)
      case .dark:
        self.effect = Self.createEffect(type: .dark)
      case .unspecified:
        break
      @unknown default:
        break
      }
    }
  }

  private enum EffectType {
    case light
    case dark
  }

  private static func createEffect(type: EffectType) -> UIBlurEffect {
    switch type {
    case .light:
      return UIBlurEffect(style: Theme.colors.lightBlurStyle)
    case .dark:
      return UIBlurEffect(style: Theme.colors.darkBlurStyle)
    }
  }
}
