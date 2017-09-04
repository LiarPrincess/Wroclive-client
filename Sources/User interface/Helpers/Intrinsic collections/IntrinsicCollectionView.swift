//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

// Source: https://stackoverflow.com/a/36748027
class IntrinsicCollectionView: UICollectionView {

  override var intrinsicContentSize: CGSize {
    return self.contentSize
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    if bounds.size != intrinsicContentSize {
      invalidateIntrinsicContentSize()
    }
  }
}
