// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

struct FontAwesomeFont: Font {
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
    let name           = "FontAwesome"
    let baseSize       = AppEnvironment.device.preferredFontSize
    let fontDescriptor = UIFontDescriptor(name: name, size: baseSize)

    self.headline    = UIFont(descriptor: fontDescriptor, size: baseSize + 18.0)
    self.subheadline = UIFont(descriptor: fontDescriptor, size: baseSize +  6.0)
    self.body        = UIFont(descriptor: fontDescriptor, size: baseSize +  1.0)
    self.bodyBold    = UIFont(descriptor: fontDescriptor, size: baseSize +  1.0)
    self.caption     = UIFont(descriptor: fontDescriptor, size: baseSize -  1.0)
  }
}
