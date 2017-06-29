//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct AvenirFontProvider: FontProvider {
  private(set) var headline    = UIFont()
  private(set) var subheadline = UIFont()
  private(set) var body        = UIFont()
  private(set) var bodyBold    = UIFont()

  init() {
    self.recalculateSizes()
  }

  mutating func recalculateSizes() {
    // 17pt for UIContentSizeCategoryLarge
    let preferredFontSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize

    self.headline    = UIFont(name: "AvenirNext-DemiBold", size: preferredFontSize + 19.0)!
    self.subheadline = UIFont(name: "AvenirNext-DemiBold", size: preferredFontSize +  7.0)!
    self.body        = UIFont(name: "AvenirNext-Medium",   size: preferredFontSize +  1.0)!
    self.bodyBold    = UIFont(name: "AvenirNext-DemiBold", size: preferredFontSize)!
  }
}
