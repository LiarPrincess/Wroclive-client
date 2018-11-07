// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

protocol Font {
  var headline:    UIFont { get }
  var subheadline: UIFont { get }
  var body:        UIFont { get }
  var bodyBold:    UIFont { get }
  var caption:     UIFont { get }

  var headlineTracking:    CGFloat { get }
  var subheadlineTracking: CGFloat { get }

  mutating func recalculateSizes()
}
