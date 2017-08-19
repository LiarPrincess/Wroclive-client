//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class IntrinsicTableView: UITableView {

  override var contentSize: CGSize {
    didSet { self.invalidateIntrinsicContentSize() }
  }

  override var intrinsicContentSize: CGSize {
    self.layoutIfNeeded()
    return CGSize(width: UIViewNoIntrinsicMetric, height: self.contentSize.height)
  }
}
