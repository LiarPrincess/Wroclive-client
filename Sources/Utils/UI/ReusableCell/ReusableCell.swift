//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit

//MARK: - ReusableCell

protocol ReusableCell {
  static var identifier: String { get }
}

//MARK: - UITableViewCell

extension UITableViewCell: ReusableCell {
  static var identifier: String { return String(describing: self) }
}

//MARK: - UICollectionViewCell

extension UICollectionReusableView: ReusableCell {
  static var identifier: String { return String(describing: self) }
}
