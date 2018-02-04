//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout = ColorSelectionViewControllerConstants.Layout

extension ColorSelectionViewController {

  func initLayout() {
    self.view.backgroundColor = Managers.theme.colors.configurationBackground
    self.initCollectionView()
    self.initBackButton()
  }

  private func initCollectionView() {
    self.collectionView.registerCell(ColorSelectionCell.self)
    self.collectionView.registerSupplementary(ColorSelectionSectionHeaderView.self, ofKind: .header)
    self.collectionView.registerSupplementary(ColorSelectionSectionFooterView.self, ofKind: .footer)
    self.collectionView.backgroundColor         = Managers.theme.colors.background
    self.collectionView.allowsSelection         = true
    self.collectionView.allowsMultipleSelection = true

    self.collectionView.dataSource = self.collectionViewDataSource
    self.collectionView.delegate   = self

    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func initBackButton() {
    typealias ButtonLayout = Layout.BackButton

    let image = StyleKit.drawBackArrowTemplateImage(size: ButtonLayout.imageSize)

    self.backButton.setImage(image, for: .normal)
    self.backButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
    self.backButton.contentEdgeInsets = ButtonLayout.insets

    self.view.addSubview(self.backButton)
    self.backButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
    }
  }
}
