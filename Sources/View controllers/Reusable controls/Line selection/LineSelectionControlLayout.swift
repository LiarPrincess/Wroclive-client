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
    self.collectionView.register(LineSelectionCell.self)
    self.collectionView.registerSupplementary(LineSelectionSectionHeaderView.self, ofKind: UICollectionElementKindSectionHeader)
    self.collectionView.backgroundColor         = UIColor.white
    self.collectionView.allowsSelection         = true
    self.collectionView.allowsMultipleSelection = true

    self.collectionView.dataSource = self.collectionDataSource
    self.collectionView.delegate   = self

    self.view.addSubview(self.collectionView)

    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
