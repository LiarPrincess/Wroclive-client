//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ReusableCell {
  static var identifier: String { get }
}

extension ReusableCell {
  static var identifier: String { return String(describing: self) }
}

extension UITableViewCell:             ReusableCell { }
extension UITableViewHeaderFooterView: ReusableCell { }
extension UICollectionReusableView:    ReusableCell { }
