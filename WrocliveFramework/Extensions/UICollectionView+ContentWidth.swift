// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public extension UICollectionView {
  var contentWidth: CGFloat {
    return self.bounds.width - self.contentInset.left - self.contentInset.right
  }
}
