// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Layout       = BookmarksCardConstants.Layout
private typealias TextStyles   = BookmarksCardConstants.TextStyles
private typealias Localization = Localizable.Bookmarks

extension BookmarksCard {

  func initLayout() {
    self.view.backgroundColor = Theme.colors.background

    self.initHeader()
    self.initTableView()
    self.initPlaceholder()

    self.view.bringSubview(toFront: self.headerView)
    self.view.sendSubview(toBack: self.placeholderView)
  }

  // MARK: - Private

  private func initHeader() {
    self.headerView.contentView.addBorder(at: .bottom)
    self.headerView.setContentHuggingPriority(UILayoutPriority(rawValue: 900), for: .vertical)

    self.view.addSubview(self.headerView, constraints: [
      make(\UIView.topAnchor, equalToSuperview: \UIView.topAnchor),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor)
    ])

    self.titleLabel.attributedText = NSAttributedString(string: Localization.title, attributes: TextStyles.cardTitle)
    self.titleLabel.numberOfLines  = 0
    self.titleLabel.lineBreakMode  = .byWordWrapping

    self.headerView.contentView.addSubview(self.titleLabel, constraints: [
      make(\UIView.topAnchor, equalTo: self.chevronView.bottomAnchor, constant: Layout.Header.Title.topOffset),
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor, constant: -Layout.Header.Title.bottomOffset),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor, constant: Layout.leftInset)
    ])

    self.editButton.contentEdgeInsets       = Layout.Header.Edit.insets
    self.editButton.accessibilityIdentifier = "BookmarksViewController.edit"

    self.headerView.contentView.addSubview(self.editButton, constraints: [
      make(\UIView.lastBaselineAnchor, equalTo: self.titleLabel.lastBaselineAnchor),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor)
    ])

    self.view.bringSubview(toFront: self.chevronViewContainer)
  }

  private func initTableView() {
    self.tableView.registerCell(BookmarksCell.self)
    self.tableView.separatorInset     = .zero
    self.tableView.backgroundColor    = Theme.colors.background
    self.tableView.rowHeight          = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = Layout.TableView.estimatedCellHeight

    // remove empty cells below (http://swiftandpainless.com/table-view-footer-in-plain-table-view/)
    self.tableView.tableFooterView = UIView(frame: .zero)

    self.view.addSubview(self.tableView, constraints: makeEdgesEqualToSuperview())
  }

  private func initPlaceholder() {
    // we can't use 'self.bookmarksTable.backgroundView' as this would result in incorrect left <-> right constraints
    self.view.addSubview(self.placeholderView, constraints: [
      make(\UIView.centerYAnchor, equalToSuperview: \UIView.centerYAnchor),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor, constant: Layout.Placeholder.leftInset),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor, constant: -Layout.Placeholder.rightInset)
    ])
  }
}
