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
  }

  // MARK: - Private

  private func initHeader() {
    self.headerView.contentView.addBorder(at: .bottom)
    self.headerView.setContentHuggingPriority(UILayoutPriority(rawValue: 900), for: .vertical)

    self.view.addSubview(self.headerView, constraints: [
      self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.headerView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
      self.headerView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
    ])

    self.titleLabel.attributedText = NSAttributedString(string: Localization.title, attributes: TextStyles.cardTitle)
    self.titleLabel.numberOfLines  = 0
    self.titleLabel.lineBreakMode  = .byWordWrapping

    self.headerView.contentView.addSubview(self.titleLabel, constraints: [
      self.titleLabel.topAnchor.constraint(equalTo: self.chevronView.bottomAnchor, constant: Layout.Header.Title.topOffset),
      self.titleLabel.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: -Layout.Header.Title.bottomOffset),
      self.titleLabel.leftAnchor.constraint(equalTo: self.headerView.leftAnchor, constant: Layout.leftInset)
    ])

    self.editButton.contentEdgeInsets       = Layout.Header.Edit.insets
    self.editButton.accessibilityIdentifier = "BookmarksViewController.edit"

    self.headerView.contentView.addSubview(self.editButton, constraints: [
      self.editButton.firstBaselineAnchor.constraint(equalTo: self.titleLabel.firstBaselineAnchor),
      self.editButton.rightAnchor.constraint(equalTo: self.headerView.rightAnchor)
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

    self.view.addSubview(self.tableView, constraints: [
      self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
      self.tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
    ])

    self.view.sendSubview(toBack: self.tableView)
  }

  private func initPlaceholder() {
    // we cant use 'self.bookmarksTable.backgroundView' as this would result in incorrect left <-> right constraints
    self.view.addSubview(self.placeholderView, constraints: [
      self.placeholderView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      self.placeholderView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: Layout.Placeholder.leftInset),
      self.placeholderView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -Layout.Placeholder.rightInset)
    ])
  }
}
