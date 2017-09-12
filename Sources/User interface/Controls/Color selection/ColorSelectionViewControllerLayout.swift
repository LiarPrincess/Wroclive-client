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

    // table view
    self.tableView.register(UITableViewCell.self)
    self.tableView.allowsMultipleSelection = true
    self.tableView.backgroundColor = Managers.theme.colorScheme.configurationBackground
    self.tableView.separatorInset  = .zero
    self.tableView.dataSource      = self.tableViewDataSource
    self.tableView.delegate        = self
    self.tableView.tableFooterView = UIView()

    self.scrollViewContent.addSubview(self.tableView)
    self.tableView.snp.makeConstraints { make in
      make.top.equalTo(self.themePresentation.view.snp.bottom)
      make.bottom.centerX.width.equalToSuperview()
    }
  }

  private func initBackButton() {
    typealias ButtonLayout = Layout.BackButton

    let image = StyleKit.drawBackTemplateImage(size: ButtonLayout.imageSize)

    self.backButton.setImage(image, for: .normal)
    self.backButton.addTarget(self, action: #selector(ColorSelectionViewController.closeButtonPressed), for: .touchUpInside)
    self.backButton.contentEdgeInsets = UIEdgeInsets(top: ButtonLayout.topInset, left: ButtonLayout.leftInset, bottom: ButtonLayout.bottomInset, right: ButtonLayout.rightInset)

    self.view.addSubview(self.backButton)
    self.backButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
    }
  }
}
