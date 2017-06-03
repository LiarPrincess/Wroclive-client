//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = LineSelectionControlConstants
fileprivate typealias Layout    = Constants.Layout

extension LineSelectionControl {

  func initLayout() {
    self.collection.register(LineSelectionCell.self)
    self.collection.registerSupplementary(LineSelectionSectionHeaderView.self, ofKind: UICollectionElementKindSectionHeader)
    self.collection.backgroundColor         = UIColor.white
    self.collection.allowsSelection         = true
    self.collection.allowsMultipleSelection = true

    self.collection.dataSource = self.dataSource
    self.collection.delegate   = self

    self.view.addSubview(self.collection)

    self.collection.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
