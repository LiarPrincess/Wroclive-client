// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

struct FontAwesome: FontPreset {
  private(set) var headline    = UIFont()
  private(set) var subheadline = UIFont()
  private(set) var body        = UIFont()
  private(set) var bodyBold    = UIFont()
  private(set) var caption     = UIFont()

  var headlineTracking:    CGFloat { return 0.50 }
  var subheadlineTracking: CGFloat { return 0.25 }

  init() {
    self.recalculateSizes()
  }

  mutating func recalculateSizes() {
    let font     = Fonts.FontAwesome.regular
    let baseSize = AppEnvironment.device.preferredFontSize

    self.headline    = UIFont(font: font, size: baseSize + 18.0)
    self.subheadline = UIFont(font: font, size: baseSize +  6.0)
    self.body        = UIFont(font: font, size: baseSize +  1.0)
    self.bodyBold    = UIFont(font: font, size: baseSize +  1.0)
    self.caption     = UIFont(font: font, size: baseSize -  1.0)
  }
}
