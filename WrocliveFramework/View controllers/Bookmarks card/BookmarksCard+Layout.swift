// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Localization = Localizable.Bookmarks

internal extension BookmarksCard {

  func initLayout() {
    self.view.backgroundColor = Theme.colors.background
    self.initHeader()
    self.initTableView()
    self.initPlaceholder()
  }

  private func initHeader() {
    let device = self.environment.device
    self.headerView.contentView.addBottomBorder(device: device)
    self.headerView.setContentHuggingPriority(900, for: .vertical)

    self.view.addSubview(self.headerView)
    self.headerView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }

    self.titleLabel.attributedText = NSAttributedString(
      string: Localization.title,
      attributes: Constants.Header.Title.attributes
    )
    self.titleLabel.numberOfLines = 0
    self.titleLabel.lineBreakMode = .byWordWrapping
    self.titleLabel.adjustsFontForContentSizeCategory = true

    self.headerView.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Constants.Header.Title.topOffset)
      make.bottom.equalToSuperview().offset(-Constants.Header.Title.bottomOffset)
      make.left.equalToSuperview().offset(Constants.leftInset)
    }

    self.editButton.contentEdgeInsets = Constants.Header.Edit.insets
    self.editButton.addTarget(self,
                              action: #selector(editButtonPressed),
                              for: .touchUpInside)

    self.headerView.contentView.addSubview(self.editButton)
    self.editButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.titleLabel.snp.lastBaseline)
      make.right.equalToSuperview()
    }
  }

  private func initTableView() {
    self.tableView.registerCell(BookmarksCell.self)
    self.tableView.separatorInset     = .zero
    self.tableView.backgroundColor    = Theme.colors.background
    self.tableView.rowHeight          = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = Constants.TableView.estimatedCellHeight

    // Remove empty cells below, see:
    // http://swiftandpainless.com/table-view-footer-in-plain-table-view/
    self.tableView.tableFooterView = UIView(frame: .zero)

    self.view.insertSubview(self.tableView, belowSubview: self.headerView)
    self.tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }

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
