//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout = ColorSelectionViewControllerConstants.Layout

extension ColorSelectionViewController {

  func initLayout() {
    self.view.backgroundColor = self.managers.theme.colorScheme.configurationBackground
    self.initScrollView()
    self.initBackButton()
  }

  private func initScrollView() {
    self.scrollView.delegate = self
    self.scrollView.alwaysBounceVertical = true
    self.scrollView.showsHorizontalScrollIndicator = false

    self.view.addSubview(self.scrollView)
    self.scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    scrollView.addSubview(self.scrollViewContent)
    self.scrollViewContent.snp.makeConstraints { make in
      make.top.bottom.centerX.width.equalToSuperview()
    }

    // presentation
    self.addChildViewController(self.themePresentation)
    self.scrollViewContent.addSubview(self.themePresentation.view)

    self.themePresentation.view.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.centerX.width.equalToSuperview()
      make.height.equalTo(UIScreen.main.bounds.height * Layout.Presentation.relativeHeight)
    }

    self.themePresentation.didMove(toParentViewController: self)

    // collection view
    self.collectionView.register(ColorSelectionCell.self)
    self.collectionView.registerSupplementary(ColorSelectionSectionHeaderView.self, ofKind: .header)
    self.collectionView.registerSupplementary(ColorSelectionSectionFooterView.self, ofKind: .footer)
    self.collectionView.backgroundColor         = self.managers.theme.colorScheme.background
    self.collectionView.allowsSelection         = true
    self.collectionView.allowsMultipleSelection = true

    self.collectionView.dataSource = self.collectionViewDataSource
    self.collectionView.delegate   = self

    self.scrollViewContent.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints { make in
      make.top.equalTo(self.themePresentation.view.snp.bottom)
      make.centerX.width.equalToSuperview()
      make.bottom.equalToSuperview().offset(-Layout.bottomOffset)
    }
  }

  private func initBackButton() {
    typealias ButtonLayout = Layout.BackButton

    let image = StyleKit.drawBackTemplateImage(size: ButtonLayout.imageSize)

    self.backButton.setImage(image, for: .normal)
    self.backButton.addTarget(self, action: #selector(ColorSelectionViewController.closeButtonPressed), for: .touchUpInside)
    self.backButton.contentEdgeInsets = ButtonLayout.insets

    self.view.addSubview(self.backButton)
    self.backButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
    }
  }
}
