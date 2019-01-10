// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Layout       = SettingsCardConstants.Layout
private typealias TextStyles   = SettingsCardConstants.TextStyles
private typealias Localization = Localizable.Settings

public extension SettingsCard {

  public func initLayout() {
    self.view.backgroundColor = Theme.colors.background

    self.initHeader()
    self.initTableView()
  }

  // MARK: - Private

  private func initHeader() {
    self.headerView.contentView.addBottomBorder()
    self.headerView.setContentHuggingPriority(UILayoutPriority(rawValue: 900), for: .vertical)

    self.view.addSubview(self.headerView, constraints: [
      make(\UIView.topAnchor,   equalToSuperview: \UIView.topAnchor),
      make(\UIView.leftAnchor,  equalToSuperview: \UIView.leftAnchor),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor)
    ])

    self.titleLabel.attributedText = NSAttributedString(string: Localization.title, attributes: TextStyles.cardTitle)
    self.titleLabel.numberOfLines  = 0
    self.titleLabel.lineBreakMode  = .byWordWrapping

    self.headerView.contentView.addSubview(self.titleLabel, constraints: [
      make(\UIView.topAnchor,    equalToSuperview: \UIView.topAnchor,    constant: Layout.Header.topInset),
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor, constant: -Layout.Header.bottomInset),
      make(\UIView.leftAnchor,   equalToSuperview: \UIView.leftAnchor,   constant: Layout.leftInset),
      make(\UIView.rightAnchor,  equalToSuperview: \UIView.rightAnchor,  constant: -Layout.rightInset)
    ])
  }

  private func initTableView() {
    self.tableView.registerCell(SettingsTextCell.self)
    self.tableView.registerSupplementary(SettingsSectionHeaderView.self)

    self.tableView.separatorStyle     = .none
    self.tableView.backgroundColor    = Theme.colors.background
    self.tableView.rowHeight          = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = Layout.TableView.estimatedCellHeight

    self.tableView.tableFooterView = SettingsCardFooterView()

    self.view.insertSubview(self.tableView, belowSubview: self.headerView, constraints: makeEdgesEqualToSuperview())
  }
}
