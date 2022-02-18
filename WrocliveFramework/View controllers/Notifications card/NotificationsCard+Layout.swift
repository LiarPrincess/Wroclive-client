// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Localization = Localizable.Notifications

extension NotificationsCard {

  internal func initLayout() {
    self.view.tintColor = ColorScheme.tint
    self.view.backgroundColor = ColorScheme.background
    self.initHeader()
    self.initTableView()
    self.initPlaceholder()
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
    self.titleLabel.attributedText = NSAttributedString(string: text,
                                                        attributes: attributes)
    self.titleLabel.adjustsFontForContentSizeCategory = true
  }

  // MARK: - Table view

  private func initTableView() {
    self.tableView.registerCell(NotificationsCell.self)
    self.tableView.separatorInset = .zero
    self.tableView.backgroundColor = ColorScheme.background
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = Constants.TableView.estimatedCellHeight
    self.tableView.delegate = self
    self.tableView.dataSource = self

    // Remove empty cells below, see:
    // http://swiftandpainless.com/table-view-footer-in-plain-table-view/
    self.tableView.tableFooterView = UIView(frame: .zero)

    self.view.insertSubview(self.tableView, belowSubview: self.headerView)
    self.tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }

  // MARK: - Placeholder

  private func initPlaceholder() {
    // We can't use 'self.bookmarksTable.backgroundView' as this would result
    // in incorrect left <-> right constraints

    self.view.insertSubview(self.placeholderView, belowSubview: self.tableView)
    self.placeholderView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().offset(Constants.Placeholder.leftInset)
      make.right.equalToSuperview().offset(-Constants.Placeholder.rightInset)
    }
  }
}
