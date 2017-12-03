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
    self.view.backgroundColor = Managers.theme.colors.background
    self.initHeader()
    self.initContent()
  }

  private func initHeader() {
    self.headerView.contentView.addBorder(at: .bottom)
    self.headerView.setContentHuggingPriority(UILayoutPriority(rawValue: 900), for: .vertical)

    self.view.addSubview(self.headerView)
    self.headerView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    let titleAttributes           = Managers.theme.textAttributes(for: .headline)
    self.cardTitle.attributedText = NSAttributedString(string: Localization.title, attributes: titleAttributes)
    self.cardTitle.numberOfLines  = 0
    self.cardTitle.lineBreakMode  = .byWordWrapping

    self.headerView.contentView.addSubview(self.cardTitle)
    self.cardTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Header.topInset)
      make.bottom.equalToSuperview().offset(-Layout.Header.bottomInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
    }
  }

  private func initContent() {
    self.tableView.register(UITableViewCell.self)
    self.tableView.backgroundColor = Managers.theme.colors.configurationBackground
    self.tableView.separatorInset  = .zero
    self.tableView.dataSource      = self.tableViewDataSource
    self.tableView.delegate        = self

    self.tableView.tableFooterView = self.createTableFooter()

    self.view.insertSubview(self.tableView, belowSubview: self.headerView)
    self.tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
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
      make.left.right.bottom.equalToSuperview()
    }

    return footerView
  }

  private func createTableFooterText() -> NSAttributedString {
    let textAttributes = Managers.theme.textAttributes(for: .caption, alignment: .center, lineSpacing: Layout.Footer.lineSpacing)
    return NSAttributedString(string: Localization.footer, attributes: textAttributes)
  }

  private func calculateMinFooterHeight(_ footerContent: NSAttributedString) -> CGFloat {
    let textRect = CGSize(width: Managers.device.screenBounds.width, height: CGFloat.infinity)
    let textSize = footerContent.boundingRect(with: textRect, options: .usesLineFragmentOrigin, context: nil)
    return textSize.height + Layout.Footer.topOffset + Layout.Footer.bottomOffset
  }
}
