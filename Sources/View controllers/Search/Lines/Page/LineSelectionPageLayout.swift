//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

extension LineSelectionPage {

  func initLayout() {
    self.collectionView.register(LineSelectionCell.self)
    self.collectionView.registerSupplementary(LineSelectionHeaderView.self, ofKind: .header)
    self.collectionView.backgroundColor         = Managers.theme.colors.background
    self.collectionView.allowsSelection         = true
    self.collectionView.allowsMultipleSelection = true
    self.collectionView.alwaysBounceVertical    = true

    self.collectionView.dataSource = self.collectionDataSource
    self.collectionView.delegate   = self

    self.view.addSubview(self.collectionView)

    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
