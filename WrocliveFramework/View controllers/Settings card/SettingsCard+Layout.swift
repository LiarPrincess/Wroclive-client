// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Localization = Localizable.Settings

extension SettingsCard {

  internal func initLayout() {
    self.view.backgroundColor = ColorScheme.background
    self.initHeader()
    self.initTableView()
  }

  // MARK: - Header

  private func initHeader() {
    self.headerView.contentView.addBottomBorder()
    self.headerView.setContentHuggingPriority(900, for: .vertical)

    self.view.addSubview(self.headerView)
    self.headerView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }

    self.initTitleLabel(text: Localization.title,
                        attributes: Constants.Header.titleAttributes)

    self.headerView.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Constants.Header.topInset)
      make.bottom.equalToSuperview().offset(-Constants.Header.bottomInset)
      make.left.equalToSuperview().offset(Constants.leftInset)
      make.right.equalToSuperview().offset(-Constants.rightInset)
    }
  }

  private func initTitleLabel(text: String,
                              attributes: TextAttributes) {
    self.titleLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
    self.titleLabel.adjustsFontForContentSizeCategory = true
  }

  // MARK: - Table view

  private func initTableView() {
    self.tableView.registerCell(SettingsLinkCell.self)
    self.tableView.registerSupplementary(SettingsSectionHeaderView.self)

    self.tableView.separatorStyle = .none
    self.tableView.backgroundColor = ColorScheme.background
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = Constants.TableView.estimatedCellHeight
    self.tableView.delegate = self
    self.tableView.dataSource = self

    let device = self.environment.device
    self.tableView.tableFooterView = SettingsCardFooterView(device: device)

    self.view.insertSubview(self.tableView, belowSubview: self.headerView)
    self.tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
}
