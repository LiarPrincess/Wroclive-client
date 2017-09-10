//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

// Source: https://stackoverflow.com/a/36748027
class IntrinsicCollectionView: UICollectionView {

  // MARK: - Properties

  override var intrinsicContentSize: CGSize {
    return self.contentSize
  }

  // MARK: - Init

  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    self.commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.commonInit()
  }

  private func commonInit() {
    self.isScrollEnabled = false
  }

  // MARK: - Methods

  override func layoutSubviews() {
    super.layoutSubviews()
    if bounds.size != intrinsicContentSize {
      invalidateIntrinsicContentSize()
    }
  }
}
