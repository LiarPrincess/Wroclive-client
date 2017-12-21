//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = BookmarksViewControllerConstants.Layout
private typealias TextStyles   = BookmarksViewControllerConstants.TextStyles
private typealias Localization = Localizable.Bookmarks

extension BookmarksViewController {

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

    self.cardTitle.attributedText = NSAttributedString(string: Localization.cardTitle, attributes: TextStyles.cardTitle)
    self.cardTitle.numberOfLines  = 0
    self.cardTitle.lineBreakMode  = .byWordWrapping

    self.headerView.contentView.addSubview(self.cardTitle)
    self.cardTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Header.topInset)
      make.bottom.equalToSuperview().offset(-Layout.Header.bottomInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
    }

    self.setEditButtonEdit()
    self.editButton.contentEdgeInsets = Layout.Header.editButtonInsets
    self.editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
    self.editButton.accessibilityIdentifier = "BookmarksViewController.edit"

    self.headerView.contentView.addSubview(self.editButton)
    self.editButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.cardTitle.snp.lastBaseline)
      make.right.equalToSuperview()
    }
  }

  private func initBookmarksTable() {
    self.bookmarksTable.register(BookmarkCell.self)
    self.bookmarksTable.separatorInset  = UIEdgeInsets(top: 0.0, left: Layout.leftInset, bottom: 0.0, right: Layout.rightInset)
    self.bookmarksTable.backgroundColor = Managers.theme.colors.background
    self.bookmarksTable.dataSource      = self.bookmarksTableDataSource
    self.bookmarksTable.delegate        = self

    // remove empty cells below (http://swiftandpainless.com/table-view-footer-in-plain-table-view/)
    self.bookmarksTable.tableFooterView = UIView(frame: .zero)

    self.view.insertSubview(self.bookmarksTable, belowSubview: self.headerView)
    self.bookmarksTable.snp.makeConstraints { make in
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
