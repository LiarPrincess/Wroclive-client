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
    Managers.theme.applyCardPanelStyle(self.view)
    self.view.backgroundColor = Managers.theme.colorScheme.configurationBackground

    self.initHeader()
    self.initScrollView()
    self.initInAppPurchaseView()
    self.initConfigurationTable()
  }

  private func initHeader() {
    Managers.theme.applyCardPanelHeaderStyle(self.headerView)
    self.view.addSubview(self.headerView)

    self.headerView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.chevronView.state             = .down
    self.chevronView.color             = Managers.theme.colorScheme.backgroundAccent
    self.chevronView.animationDuration = Constants.Animations.chevronDismissRelativeDuration
    self.view.addSubview(chevronView)

    self.chevronView.snp.makeConstraints { make in
      let chevronViewSize = ChevronView.nominalSize

      make.top.equalToSuperview().offset(Layout.Header.chevronY)
      make.centerX.equalToSuperview()
      make.width.equalTo(chevronViewSize.width)
      make.height.equalTo(chevronViewSize.height)
    }

    let titleAttributes           = Managers.theme.textAttributes(for: .headline)
    self.cardTitle.attributedText = NSAttributedString(string: Localization.Title, attributes: titleAttributes)
    self.cardTitle.numberOfLines  = 0
    self.cardTitle.lineBreakMode  = .byWordWrapping
    self.headerView.addSubview(self.cardTitle)

    self.cardTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Header.topInset)
      make.bottom.equalToSuperview().offset(-Layout.Header.bottomInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
    }
  }

  private func initScrollView() {
    self.scrollView.delegate = self
    self.scrollView.alwaysBounceVertical = true
    self.scrollView.showsHorizontalScrollIndicator = false

    self.view.insertSubview(self.scrollView, belowSubview: self.headerView)
    self.scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    scrollView.addSubview(self.scrollViewContent)
    self.scrollViewContent.snp.makeConstraints { make in
      make.top.bottom.centerX.width.equalToSuperview()
    }
  }

  private func initInAppPurchaseView() {
    self.addChildViewController(self.inAppPurchasePresentation)
    self.scrollViewContent.addSubview(self.inAppPurchasePresentation.view)

    self.inAppPurchasePresentation.view.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.centerX.width.equalToSuperview()
      make.height.equalTo(self.viewSize)
    }

    self.inAppPurchasePresentation.didMove(toParentViewController: self)
  }

  private func initConfigurationTable() {
    self.configurationTable.backgroundColor      = Managers.theme.colorScheme.configurationBackground
    self.configurationTable.alwaysBounceVertical = false // disable scrolling
    self.configurationTable.separatorInset = .zero
    self.configurationTable.dataSource     = self
    self.configurationTable.delegate       = self

    self.scrollViewContent.addSubview(self.configurationTable)
    self.configurationTable.snp.makeConstraints { make in
      make.top.equalTo(self.inAppPurchasePresentation.view.snp.bottom)
      make.bottom.centerX.width.equalToSuperview()
    }

    self.initConfigurationTableCells()
    self.initConfigurationTableFooter()
  }

  private func initConfigurationTableCells() {
    let textAttributes = Managers.theme.textAttributes(for: .body)

    self.colorsCell  .textLabel?.attributedText = NSAttributedString(string: Localization.Cells.colors,   attributes: textAttributes)
    self.shareCell   .textLabel?.attributedText = NSAttributedString(string: Localization.Cells.share,    attributes: textAttributes)
    self.tutorialCell.textLabel?.attributedText = NSAttributedString(string: Localization.Cells.tutorial, attributes: textAttributes)
    self.contactCell .textLabel?.attributedText = NSAttributedString(string: Localization.Cells.contact,  attributes: textAttributes)
    self.rateCell    .textLabel?.attributedText = NSAttributedString(string: Localization.Cells.rate,     attributes: textAttributes)

    let cells = [self.colorsCell, self.shareCell, self.tutorialCell, self.contactCell, self.rateCell]
    for cell in cells {
      cell.accessoryType   = .disclosureIndicator
      cell.backgroundColor = Managers.theme.colorScheme.background
    }
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
