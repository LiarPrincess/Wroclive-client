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
    self.initNoNotificationsView()
    self.initLoadingView()
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

  // MARK: - No notifications

  private func initNoNotificationsView() {
    // We can't use 'self.bookmarksTable.backgroundView' as this would result
    // in incorrect left <-> right constraints

    let label = UILabel()

    label.attributedText = NSAttributedString(
      string: Localization.noNotifications,
      attributes: Constants.NoNotifications.textAttributes
    )

    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.adjustsFontForContentSizeCategory = true

    self.noNotificationsView.addSubview(label)
    label.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    self.view.insertSubview(self.noNotificationsView, belowSubview: self.tableView)
    self.noNotificationsView.snp.makeConstraints { make in
      make.top.equalTo(self.headerView.contentView.snp.bottom)
      make.bottom.left.right.equalToSuperview()
    }
  }

  // MARK: - Loading view

  private func initLoadingView() {
    // We can't use 'self.bookmarksTable.backgroundView' as this would result
    // in incorrect left <-> right constraints

    self.view.insertSubview(self.loadingView, belowSubview: self.noNotificationsView)
    self.loadingView.snp.makeConstraints { make in
      make.top.equalTo(self.headerView.contentView.snp.bottom)
      make.bottom.left.right.equalToSuperview()
    }
  }
}
