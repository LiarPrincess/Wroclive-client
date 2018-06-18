//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

extension UICollectionView {
  var contentWidth: CGFloat {
    return self.bounds.width - self.contentInset.left - self.contentInset.right
  }
}
