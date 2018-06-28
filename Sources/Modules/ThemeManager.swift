// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import Foundation

// source: https://medium.com/@abhimuralidharan/maintaining-a-colour-theme-manager-on-ios-swift-178b8a6a92
// sourcery: manager
class ThemeManager: ThemeManagerType {

  // MARK: - Properties

  fileprivate(set) lazy var textFont: Font        = SystemFont()
  fileprivate(set) lazy var iconFont: Font        = FontAwesomeFont()
  fileprivate(set) lazy var colors:   ColorScheme = ColorScheme()

  // MARK: - Fonts

  func recalculateFontSizes() {
    self.textFont.recalculateSizes()
    self.iconFont.recalculateSizes()
  }
}
