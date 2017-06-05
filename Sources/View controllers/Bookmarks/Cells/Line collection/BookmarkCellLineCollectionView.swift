//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class BookmarkCellLineCollectionView: UICollectionView {
  override var intrinsicContentSize: CGSize {
    return self.collectionViewLayout.collectionViewContentSize
  }
}
