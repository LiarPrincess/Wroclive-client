//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

class ColorSelectionSectionFooterView: UICollectionReusableView {

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = Managers.theme.colorScheme.configurationBackground
    self.addBorder(at: .top)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
