//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct SystemFont: Font {
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
    let preferredFontSize = Managers.device.preferredFontSize

    self.headline    = UIFont.systemFont(ofSize: preferredFontSize + 17.0, weight: UIFont.Weight.bold)
    self.subheadline = UIFont.systemFont(ofSize: preferredFontSize +  5.0, weight: UIFont.Weight.bold)
    self.body        = UIFont.systemFont(ofSize: preferredFontSize,        weight: UIFont.Weight.regular)
    self.bodyBold    = UIFont.systemFont(ofSize: preferredFontSize,        weight: UIFont.Weight.bold)
    self.caption     = UIFont.systemFont(ofSize: preferredFontSize -  2.0, weight: UIFont.Weight.regular)
  }
}
