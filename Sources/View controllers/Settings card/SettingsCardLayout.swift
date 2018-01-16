//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = SettingsCardConstants.Layout
private typealias TextStyles   = SettingsCardConstants.TextStyles
private typealias Localization = Localizable.Configuration

extension SettingsCard {

  func initLayout() {
    self.view.backgroundColor = Managers.theme.colors.background
    self.initHeader()
    self.initTableView()
  }

  // MARK: - Private

  private func initHeader() {
    self.headerView.contentView.addBorder(at: .bottom)
    self.headerView.setContentHuggingPriority(UILayoutPriority(rawValue: 900), for: .vertical)

    self.view.addSubview(self.headerView)
    self.headerView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.titleLabel.attributedText = NSAttributedString(string: Localization.title, attributes: TextStyles.cardTitle)
    self.titleLabel.numberOfLines  = 0
    self.titleLabel.lineBreakMode  = .byWordWrapping

    self.headerView.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Header.topInset)
      make.bottom.equalToSuperview().offset(-Layout.Header.bottomInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
    }
  }

  private func initTableView() {
    self.tableView.register(UITableViewCell.self)
//    self.tableView.separatorInset     = .zero
//    self.tableView.separatorColor     = Managers.theme.colors.accentLight
//    self.tableView.backgroundColor    = Managers.theme.colors.background
    self.tableView.rowHeight          = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = Layout.TableView.estimatedCellHeight

    self.tableView.tableFooterView = SettingsCardFooterView()

    self.view.insertSubview(self.tableView, belowSubview: self.headerView)
    self.tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
