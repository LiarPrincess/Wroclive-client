//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct SystemFontProvider: FontProvider {
  private(set) var headline    = UIFont()
  private(set) var subheadline = UIFont()
  private(set) var body        = UIFont()

  init() {
    self.recalculateSizes()
  }

  mutating  func recalculateSizes() {
    self.headline    = UIFont.systemFont(ofSize: 35, weight: UIFontWeightMedium)
    self.subheadline = UIFont.systemFont(ofSize: 23, weight: UIFontWeightMedium)
    self.body        = UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
  }
}

