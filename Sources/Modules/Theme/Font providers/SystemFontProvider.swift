//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct SystemFontProvider: FontProvider {
  private(set) var headline    = UIFont()
  private(set) var subheadline = UIFont()
  private(set) var body        = UIFont()
  private(set) var bodyBold    = UIFont()

  var headlineTracking:    CGFloat { return 0.50 }
  var subheadlineTracking: CGFloat { return 0.25 }

  init() {
    self.recalculateSizes()
  }

  mutating func recalculateSizes() {
    // 17pt for UIContentSizeCategoryLarge
    let defaultFontSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize

    self.headline    = UIFont.systemFont(ofSize: defaultFontSize + 17.0, weight: UIFontWeightBold)
    self.subheadline = UIFont.systemFont(ofSize: defaultFontSize +  5.0, weight: UIFontWeightBold)
    self.body        = UIFont.systemFont(ofSize: defaultFontSize,        weight: UIFontWeightRegular)
    self.bodyBold    = UIFont.systemFont(ofSize: defaultFontSize,        weight: UIFontWeightBold)
  }
}
