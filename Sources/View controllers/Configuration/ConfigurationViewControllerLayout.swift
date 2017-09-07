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

    // in-app purchase
    self.addChildViewController(self.inAppPurchasePresentation)
    self.scrollViewContent.addSubview(self.inAppPurchasePresentation.view)

    self.inAppPurchasePresentation.view.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.centerX.width.equalToSuperview()
      make.height.equalTo(self.viewSize)
    }

    self.inAppPurchasePresentation.didMove(toParentViewController: self)

    // table view
    self.tableView.register(UITableViewCell.self)
    self.tableView.backgroundColor = Managers.theme.colorScheme.configurationBackground
    self.tableView.separatorInset  = .zero
    self.tableView.dataSource      = self.tableViewDataSource
    self.tableView.delegate        = self

    self.scrollViewContent.addSubview(self.tableView)
    self.tableView.snp.makeConstraints { make in
      make.top.equalTo(self.inAppPurchasePresentation.view.snp.bottom)
      make.bottom.centerX.width.equalToSuperview()
    }

    self.tableView.tableFooterView = self.createTableFooter()
  }

  private func createTableFooter() -> UIView {
    let text = self.createTableFooterText()

    let footerFrame = CGRect(x: 0.0, y: 0.0, width: 1.0, height: self.calculateMinFooterHeight(text))
    let footerView = UIView(frame: footerFrame)

    let footerLabel = UILabel()
    footerLabel.attributedText = text
    footerLabel.numberOfLines  = 0

    footerView.addSubview(footerLabel)
    footerLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Footer.topOffset)
      make.left.right.equalToSuperview()
    }

    return footerView
  }

  private func createTableFooterText() -> NSAttributedString {
    let textAttributes = Managers.theme.textAttributes(for: .caption, alignment: .center, lineSpacing: Layout.Footer.lineSpacing)

    let appVersion = Managers.app.version
    let footerText = String(format: Localization.Footer, appVersion)
    return NSAttributedString(string: footerText, attributes: textAttributes)
  }

  private func calculateMinFooterHeight(_ footerContent: NSAttributedString) -> CGFloat {
    let textRect = CGSize(width: UIScreen.main.bounds.width, height: CGFloat.infinity)
    let textSize = footerContent.boundingRect(with: textRect, options: .usesLineFragmentOrigin, context: nil)
    return textSize.height + Layout.Footer.topOffset + Layout.Footer.bottomOffset
  }
}
