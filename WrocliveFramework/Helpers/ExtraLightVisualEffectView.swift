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

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if #available(iOS 12.0, *) {
      let current = self.traitCollection
      if current.hasChangedUserInterfaceStyle(comparedTo: previousTraitCollection) {
        let style = ColorScheme.blurStyle(for: current.userInterfaceStyle)
        self.effect = UIBlurEffect(style: style)
      }
    } else {
      if self.effect == nil {
        let style = ColorScheme.blurStyle(mode: .light)
        self.effect = UIBlurEffect(style: style)
      }
    }
  }
}
