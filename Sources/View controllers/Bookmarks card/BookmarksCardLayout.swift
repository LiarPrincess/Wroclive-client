//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = BookmarksCardConstants.Layout
private typealias TextStyles   = BookmarksCardConstants.TextStyles
private typealias Localization = Localizable.Bookmarks

extension BookmarksCard {

  func initLayout() {
    self.view.backgroundColor = Managers.theme.colors.background
    self.initHeader()
    self.initBookmarksTable()
    self.initPlaceholder()
  }

  // MARK: - Private

  private func initHeader() {
    self.headerView.contentView.addBorder(at: .bottom)
    self.headerView.setContentHuggingPriority(UILayoutPriority(rawValue: 900), for: .vertical)

    self.view.addSubview(self.headerView)
    self.headerView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.titleLabel.attributedText = NSAttributedString(string: Localization.cardTitle, attributes: TextStyles.cardTitle)
    self.titleLabel.numberOfLines  = 0
    self.titleLabel.lineBreakMode  = .byWordWrapping

    self.headerView.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Header.topInset)
      make.bottom.equalToSuperview().offset(-Layout.Header.bottomInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
    }

    self.editButton.contentEdgeInsets       = Layout.Header.editButtonInsets
    self.editButton.accessibilityIdentifier = "BookmarksViewController.edit"

    self.headerView.contentView.addSubview(self.editButton)
    self.editButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.titleLabel.snp.lastBaseline)
      make.right.equalToSuperview()
    }
  }

  private func initBookmarksTable() {
    self.tableView.register(BookmarkCell.self)
    self.tableView.separatorInset     = .zero
    self.tableView.backgroundColor    = Managers.theme.colors.background
    self.tableView.rowHeight          = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = Layout.TableView.estimatedCellHeight

    // remove empty cells below (http://swiftandpainless.com/table-view-footer-in-plain-table-view/)
    self.tableView.tableFooterView = UIView(frame: .zero)

    self.view.insertSubview(self.tableView, belowSubview: self.headerView)
    self.tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func initPlaceholder() {
    // we cant use 'self.bookmarksTable.backgroundView' as this would result in incorrect left <-> right constraints
    self.view.addSubview(self.placeholderView)
    self.placeholderView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(Layout.Placeholder.leftInset)
      make.right.equalToSuperview().offset(-Layout.Placeholder.rightInset)
      make.centerY.equalTo(self.view)
    }
  }
}