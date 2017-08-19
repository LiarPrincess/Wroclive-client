//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Constants    = ConfigurationViewControllerConstants
private typealias Layout       = Constants.Layout
//private typealias Localization = Constants.Localization

// navigation bar below status bar: https://stackoverflow.com/a/21548900
extension ConfigurationViewController {

  func initLayout() {
    self.view.backgroundColor = self.configurationTable.backgroundColor ?? Theme.current.colorScheme.background
    self.initNavigationBar()
    self.initConfigurationTable()
  }

  private func initNavigationBar() {
    self.navigationBar.barStyle            = Theme.current.colorScheme.barStyle
    self.navigationBar.titleTextAttributes = Theme.current.textAttributes(for: .bodyBold)
    self.navigationBar.delegate            = self
    self.view.addSubview(self.navigationBar)

    self.navigationBar.snp.makeConstraints { make in
      make.top.equalTo(self.topLayoutGuide.snp.bottom)
      make.left.right.equalToSuperview()
    }

    let closeImageSize = CGSize(width: 16.0, height: 16.0)
    let closeImage     = StyleKit.drawCloseTemplateImage(size: closeImageSize)

    let navigationItem   = UINavigationItem()
    navigationItem.title = "Settings"

    let closeNavigationItem = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(closeButtonPressed))
    navigationItem.rightBarButtonItem = closeNavigationItem
    self.navigationBar.setItems([navigationItem], animated: false)
  }

  private func initConfigurationTable() {
    self.configurationTable.alwaysBounceVertical = false
    self.configurationTable.separatorInset = .zero
    self.configurationTable.dataSource     = self
    self.configurationTable.delegate       = self
    self.view.insertSubview(self.configurationTable, belowSubview: self.navigationBar)

    self.configurationTable.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBar.snp.bottom)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }

    self.initConfigurationTableCells()
    self.initConfigurationTableFooter()
  }

  private func initConfigurationTableCells() {
    let textAttributes = Theme.current.textAttributes(for: .body)

    self.colorsCell.textLabel?.attributedText = NSAttributedString(string: "Colors", attributes: textAttributes)
    self.colorsCell.accessoryType = .disclosureIndicator

    self.shareCell.textLabel?.attributedText = NSAttributedString(string: "Tell a friend", attributes: textAttributes)
    self.shareCell.accessoryType = .disclosureIndicator

    self.tutorialCell.textLabel?.attributedText = NSAttributedString(string: "Tutorial", attributes: textAttributes)
    self.tutorialCell.accessoryType = .disclosureIndicator

    self.rateCell.textLabel?.attributedText = NSAttributedString(string: "Rate Kek", attributes: textAttributes)
    self.rateCell.accessoryType = .disclosureIndicator
  }

  private func initConfigurationTableFooter() {
    let textAttributes = Theme.current.textAttributes(for: .body, alignment: .center, lineSpacing: 5.0)
    let text           = NSAttributedString(string: "Data provided by Transport for London\nJump version 1.2 (26) Camden", attributes: textAttributes)

    let footerFrame = CGRect(x: 0.0, y: 0.0, width: 1.0, height: self.calculateMinFooterHeight(text))
    self.configurationTable.tableFooterView = UIView(frame: footerFrame)

    let footerLabel = UILabel()
    footerLabel.attributedText = text
    footerLabel.numberOfLines  = 0

    self.configurationTable.tableFooterView!.addSubview(footerLabel)
    footerLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func calculateMinFooterHeight(_ footerContent: NSAttributedString) -> CGFloat {
    let textRect = CGSize(width: UIScreen.main.bounds.width, height: CGFloat.infinity)
    let textSize = footerContent.boundingRect(with: textRect, options: .usesLineFragmentOrigin, context: nil)

    let verticalInsets: CGFloat = 2.0
    return textSize.height + verticalInsets
  }
}
