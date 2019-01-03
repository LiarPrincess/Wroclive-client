// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public protocol ReusableCell {
  static var identifier: String { get }
}

public extension ReusableCell {
  static var identifier: String { return String(describing: self) }
}

extension UITableViewCell:             ReusableCell { }
extension UITableViewHeaderFooterView: ReusableCell { }
extension UICollectionReusableView:    ReusableCell { }
