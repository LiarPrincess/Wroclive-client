//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import Foundation

protocol ThemeManagerType {

  var textFont: Font { get }
  var iconFont: Font { get }
  var colors:   ColorScheme { get }

  func recalculateFontSizes()
}
