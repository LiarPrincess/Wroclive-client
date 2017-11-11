//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Foundation

class ThemeManagerAssert: ThemeManager {

  // MARK: - Properties

  var textFont: Font        { assertNotCalled() }
  var iconFont: Font        { assertNotCalled() }
  var colors:   ColorScheme { assertNotCalled() }

  // MARK: - Fonts

  func recalculateFontSizes() {
    assertNotCalled()
  }

  // Mark - Color scheme

  func setColorScheme(tint: TintColor, tram: VehicleColor, bus: VehicleColor) {
    assertNotCalled()
  }
}
