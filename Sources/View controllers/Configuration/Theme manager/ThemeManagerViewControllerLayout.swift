//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = ThemeManagerViewControllerConstants.Layout
//private typealias Localization = Localizable.Presentation.Tutorial

extension ThemeManagerViewController {

  func initLayout() {
    self.view.backgroundColor = Managers.theme.colorScheme.background
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

    self.initPresentationView()
    self.initConfigurationTable()
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

  private func initConfigurationTable() {
    self.configurationTable.alwaysBounceVertical = false // disable scrolling
    self.configurationTable.separatorInset = .zero
    self.configurationTable.dataSource     = self
//    self.configurationTable.delegate       = self
    self.scrollViewContent.addSubview(self.configurationTable)

    self.configurationTable.snp.makeConstraints { make in
      make.top.equalTo(self.themePresentation.view.snp.bottom)
      make.bottom.centerX.width.equalToSuperview()
    }

    self.initConfigurationTableCells()
    self.initConfigurationTableFooter()
  }

  private func initConfigurationTableCells() {
    let textAttributes = Managers.theme.textAttributes(for: .body)

    self.colorsCell.textLabel?.attributedText = NSAttributedString(string: "Text", attributes: textAttributes)
    self.colorsCell.accessoryType = .disclosureIndicator

    self.shareCell.textLabel?.attributedText = NSAttributedString(string: "Text", attributes: textAttributes)
    self.shareCell.accessoryType = .disclosureIndicator

    self.tutorialCell.textLabel?.attributedText = NSAttributedString(string: "Text", attributes: textAttributes)
    self.tutorialCell.accessoryType = .disclosureIndicator

    self.contactCell.textLabel?.attributedText = NSAttributedString(string: "Text", attributes: textAttributes)
    self.contactCell.accessoryType = .disclosureIndicator

    self.rateCell.textLabel?.attributedText = NSAttributedString(string: "Text", attributes: textAttributes)
    self.rateCell.accessoryType = .disclosureIndicator
  }

  private func initConfigurationTableFooter() {
    let footerFrame = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    self.configurationTable.tableFooterView = UIView(frame: footerFrame)
  }

  private func initBackButton() {
    typealias ButtonLayout = Layout.BackButton

    let backImage = StyleKit.drawBackTemplateImage(size: ButtonLayout.imageSize)

    let button = UIButton()
    button.setImage(backImage, for: .normal)
    button.addTarget(self, action: #selector(ThemeManagerViewController.closeButtonPressed), for: .touchUpInside)
    button.contentEdgeInsets = UIEdgeInsets(top: ButtonLayout.topInset, left: ButtonLayout.leftInset, bottom: ButtonLayout.bottomInset, right: ButtonLayout.rightInset)

    self.view.addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
    }
  }
}
