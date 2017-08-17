//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants    = ConfigurationViewControllerConstants
//fileprivate typealias Layout       = Constants.Layout
//fileprivate typealias Localization = Constants.Localization

// navigation bar: https://stackoverflow.com/a/21548900
extension ConfigurationViewController {

  func initLayout() {
    self.view.backgroundColor = Theme.current.colorScheme.background

    self.initNavigationBar()
    self.initConfigurationTable()
  }

  private func initNavigationBar() {
    self.navigationBar.delegate = self
    self.view.addSubview(self.navigationBar)

    self.navigationBar.snp.makeConstraints { make in
      make.top.equalTo(self.topLayoutGuide.snp.bottom)
      make.left.right.equalToSuperview()
    }

    let closeImageSize = CGSize(width: 18.0, height: 18.0)
    let closeImage     = StyleKit.drawCloseTemplateImage(size: closeImageSize)

    let navigationItem   = UINavigationItem()
    navigationItem.title = "Settings"

    let closeNavigationItem = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(closeButtonPressed))
    navigationItem.rightBarButtonItem = closeNavigationItem
    self.navigationBar.setItems([navigationItem], animated: false)
  }

  private func initConfigurationTable() {
    self.configurationTable.separatorInset  = .zero
    self.configurationTable.dataSource      = self
    self.configurationTable.delegate        = self
    self.view.addSubview(self.configurationTable)

    self.configurationTable.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(80.0)
      make.left.bottom.right.equalToSuperview()
    }

    let textAttributes = Theme.current.textAttributes(for: .body, color: .text)

    self.colorsCell.textLabel?.attributedText = NSAttributedString(string: "Colors", attributes: textAttributes)
    self.colorsCell.accessoryType = .disclosureIndicator

    self.shareCell.textLabel?.attributedText = NSAttributedString(string: "Tell a friend", attributes: textAttributes)
    self.shareCell.accessoryType = .disclosureIndicator

    self.tutorialCell.textLabel?.attributedText = NSAttributedString(string: "Tutorial", attributes: textAttributes)
    self.tutorialCell.accessoryType = .disclosureIndicator

    self.rateCell.textLabel?.attributedText = NSAttributedString(string: "Rate Kek", attributes: textAttributes)
    self.rateCell.accessoryType = .disclosureIndicator
  }
}
