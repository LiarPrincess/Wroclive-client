//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol FontProvider {
  var headline:         UIFont  { get }
  var headlineTracking: CGFloat { get }

  var subheadline:         UIFont  { get }
  var subheadlineTracking: CGFloat { get }

  var body:        UIFont { get }
  var bodyBold:    UIFont { get }

  mutating func recalculateSizes()
}
