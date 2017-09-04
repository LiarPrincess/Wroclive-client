//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout = ColorSelectionViewControllerConstants.Layout

extension ColorSelectionViewController {

  func initLayout() {
    self.view.backgroundColor = Managers.theme.colorScheme.configurationBackground
    self.initScrollView()
    self.initPresentationView()
    self.initColorsCollection()
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
  }

  private func initPresentationView() {
    self.addChildViewController(self.themePresentation)
    self.scrollViewContent.addSubview(self.themePresentation.view)

    self.themePresentation.view.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.centerX.width.equalToSuperview()
      make.height.equalTo(UIScreen.main.bounds.height * Layout.Presentation.relativeHeight)
    }

    self.themePresentation.didMove(toParentViewController: self)
  }

  func initColorsCollection() {
    self.colorsCollection.register(UICollectionViewCell.self)
//    self.colorsCollection.registerSupplementary(LineSelectionSectionHeaderView.self, ofKind: UICollectionElementKindSectionHeader)
    self.colorsCollection.backgroundColor         = Managers.theme.colorScheme.configurationBackground
    self.colorsCollection.allowsSelection         = true
    self.colorsCollection.allowsMultipleSelection = true
    self.colorsCollection.alwaysBounceVertical    = true

    self.colorsCollection.dataSource = self
    self.colorsCollection.delegate   = self

    self.scrollViewContent.addSubview(self.colorsCollection)
    self.colorsCollection.snp.makeConstraints { make in
      make.top.equalTo(self.themePresentation.view.snp.bottom)
      make.bottom.centerX.width.equalToSuperview()
    }
  }

  private func initBackButton() {
    typealias ButtonLayout = Layout.BackButton

    let backImage = StyleKit.drawBackTemplateImage(size: ButtonLayout.imageSize)

    let button = UIButton()
    button.setImage(backImage, for: .normal)
    button.addTarget(self, action: #selector(ColorSelectionViewController.closeButtonPressed), for: .touchUpInside)
    button.contentEdgeInsets = UIEdgeInsets(top: ButtonLayout.topInset, left: ButtonLayout.leftInset, bottom: ButtonLayout.bottomInset, right: ButtonLayout.rightInset)

    self.view.addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
    }
  }
}
