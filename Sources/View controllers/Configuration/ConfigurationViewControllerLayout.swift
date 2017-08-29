//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Constants    = ConfigurationViewControllerConstants
private typealias Layout       = Constants.Layout
private typealias Localization = Localizable.Configuration

extension ConfigurationViewController {

  func initLayout() {
    self.view.backgroundColor = self.configurationTable.backgroundColor ?? Managers.theme.colorScheme.background
    self.initNavigationBar()
    self.initContentView()
  }

  private func initNavigationBar() {
    self.title = Localization.Title

    let navigationBar = self.navigationController!.navigationBar
    Managers.theme.applyNavigationBarStyle(navigationBar)
    navigationBar.titleTextAttributes = Managers.theme.textAttributes(for: .bodyBold)

    let closeImage  = StyleKit.drawCloseTemplateImage(size: Layout.NavigationBar.closeImageSize)
    let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(closeButtonPressed))
    self.navigationItem.rightBarButtonItem = closeButton
  }

  private func initContentView() {
    self.scrollView.delegate = self
    self.scrollView.showsHorizontalScrollIndicator = false

    self.view.addSubview(self.scrollView)
    self.scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    scrollView.addSubview(contentView)
    self.contentView.snp.makeConstraints { make in
      make.top.bottom.centerX.width.equalToSuperview()
    }

    self.initInAppPurchaseView()
    self.initConfigurationTable()

    let screenHeight = UIScreen.main.bounds.height
    let topInset     = -1.0 * screenHeight * Layout.Content.scrollHiddenPercent
    self.scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
  }

  private func initInAppPurchaseView() {
    self.addChildViewController(self.inAppPurchasePresentation)
    self.contentView.addSubview(self.inAppPurchasePresentation.view)

    let screenHeight = UIScreen.main.bounds.height
    self.inAppPurchasePresentation.view.snp.makeConstraints { make in
      make.top.centerX.width.equalToSuperview()
      make.height.equalTo(screenHeight + 1.0)
    }

    self.inAppPurchasePresentation.didMove(toParentViewController: self)
  }

  private func initConfigurationTable() {
    self.configurationTable.alwaysBounceVertical = false // disable scrolling
    self.configurationTable.separatorInset = .zero
    self.configurationTable.dataSource     = self
    self.configurationTable.delegate       = self
    self.contentView.addSubview(self.configurationTable)

    self.configurationTable.snp.makeConstraints { make in
      make.top.equalTo(self.inAppPurchasePresentation.view.snp.bottom)
      make.bottom.centerX.width.equalToSuperview()
    }

    self.initConfigurationTableCells()
    self.initConfigurationTableFooter()
  }

  private func initConfigurationTableCells() {
    let textAttributes = Managers.theme.textAttributes(for: .body)

    self.colorsCell.textLabel?.attributedText = NSAttributedString(string: Localization.Cells.colors, attributes: textAttributes)
    self.colorsCell.accessoryType = .disclosureIndicator

    self.shareCell.textLabel?.attributedText = NSAttributedString(string: Localization.Cells.share, attributes: textAttributes)
    self.shareCell.accessoryType = .disclosureIndicator

    self.tutorialCell.textLabel?.attributedText = NSAttributedString(string: Localization.Cells.tutorial, attributes: textAttributes)
    self.tutorialCell.accessoryType = .disclosureIndicator

    self.contactCell.textLabel?.attributedText = NSAttributedString(string: Localization.Cells.contact, attributes: textAttributes)
    self.contactCell.accessoryType = .disclosureIndicator

    self.rateCell.textLabel?.attributedText = NSAttributedString(string: Localization.Cells.rate, attributes: textAttributes)
    self.rateCell.accessoryType = .disclosureIndicator
  }

  private func initConfigurationTableFooter() {
    let textAttributes = Managers.theme.textAttributes(for: .caption, alignment: .center, lineSpacing: Layout.Footer.lineSpacing)

    let appVersion = Managers.app.version
    let footerText = String(format: Localization.Footer, appVersion)
    let text = NSAttributedString(string: footerText, attributes: textAttributes)

    let footerFrame = CGRect(x: 0.0, y: 0.0, width: 1.0, height: self.calculateMinFooterHeight(text))
    self.configurationTable.tableFooterView = UIView(frame: footerFrame)

    let footerLabel = UILabel()
    footerLabel.attributedText = text
    footerLabel.numberOfLines  = 0

    self.configurationTable.tableFooterView!.addSubview(footerLabel)
    footerLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Footer.topOffset)
      make.left.right.equalToSuperview()
    }
  }

  private func calculateMinFooterHeight(_ footerContent: NSAttributedString) -> CGFloat {
    let textRect = CGSize(width: UIScreen.main.bounds.width, height: CGFloat.infinity)
    let textSize = footerContent.boundingRect(with: textRect, options: .usesLineFragmentOrigin, context: nil)
    return textSize.height + Layout.Footer.topOffset + Layout.Footer.bottomOffset
  }
}
