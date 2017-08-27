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
    let preferredFontSize = self.preferredFontSize

    self.headline    = UIFont.systemFont(ofSize: preferredFontSize + 17.0, weight: UIFontWeightBold)
    self.subheadline = UIFont.systemFont(ofSize: preferredFontSize +  5.0, weight: UIFontWeightBold)
    self.body        = UIFont.systemFont(ofSize: preferredFontSize,        weight: UIFontWeightRegular)
    self.bodyBold    = UIFont.systemFont(ofSize: preferredFontSize,        weight: UIFontWeightBold)
    self.caption     = UIFont.systemFont(ofSize: preferredFontSize -  2.0, weight: UIFontWeightRegular)
  }
}
