//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class IntrinsicTableView: UITableView {

  // MARK: - Properties

  override var contentSize: CGSize {
    didSet { self.invalidateIntrinsicContentSize() }
  }

  override var intrinsicContentSize: CGSize {
    self.layoutIfNeeded()
    return CGSize(width: UIViewNoIntrinsicMetric, height: self.contentSize.height)
  }

  // MARK: - Init

  override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
    self.commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.commonInit()
  }

  private func commonInit() {
    self.isScrollEnabled = false
  }
}
