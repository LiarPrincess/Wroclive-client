//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Constants    = BookmarksViewControllerConstants
private typealias Layout       = Constants.Layout
private typealias Localization = Localizable.Bookmarks

extension BookmarksViewController {

  func initLayout() {
    Managers.theme.applyCardPanelStyle(self.view)
    self.initHeader()
    self.initBookmarksTable()
    self.initBookmarksTablePlaceholder()
  }

  // MARK: - Private

  private func initHeader() {
    Managers.theme.applyCardPanelHeaderStyle(self.headerView)
    self.view.addSubview(self.headerView)

    self.headerView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.chevronView.state             = .down
    self.chevronView.color             = Managers.theme.colorScheme.backgroundAccent
    self.chevronView.animationDuration = Constants.CardPanel.chevronDismissRelativeDuration
    self.view.addSubview(chevronView)

    self.chevronView.snp.makeConstraints { make in
      let chevronViewSize = ChevronView.nominalSize

      make.top.equalToSuperview().offset(Layout.Header.chevronY)
      make.centerX.equalToSuperview()
      make.width.equalTo(chevronViewSize.width)
      make.height.equalTo(chevronViewSize.height)
    }

    let titleAttributes           = Managers.theme.textAttributes(for: .headline)
    self.cardTitle.attributedText = NSAttributedString(string: Localization.cardTitle, attributes: titleAttributes)
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
    self.headerView.contentView.addSubview(self.editButton)

    self.editButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.cardTitle.snp.lastBaseline)
      make.right.equalToSuperview()
    }
  }

  private func initBookmarksTable() {
    self.bookmarksTable.register(BookmarkCell.self)
    self.bookmarksTable.separatorInset  = UIEdgeInsets(top: 0.0, left: Layout.leftInset, bottom: 0.0, right: Layout.rightInset)
    self.bookmarksTable.backgroundColor = Managers.theme.colorScheme.background
    self.bookmarksTable.dataSource      = self.bookmarksTableDataSource
    self.bookmarksTable.delegate        = self

    // remove empty cells below (http://swiftandpainless.com/table-view-footer-in-plain-table-view/)
    self.bookmarksTable.tableFooterView = UIView(frame: .zero)

    self.view.insertSubview(self.bookmarksTable, belowSubview: self.headerView)
    self.bookmarksTable.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func initBookmarksTablePlaceholder() {
    // we cant use 'self.bookmarksTable.backgroundView' as this would result in incorrect left <-> right constraints
    self.view.addSubview(self.placeholderView)

    self.placeholderView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(Layout.Placeholder.leftInset)
      make.right.equalToSuperview().offset(-Layout.Placeholder.rightInset)
      make.centerY.equalTo(self.view)
    }

    let titleAttributes = Managers.theme.textAttributes(for: .subheadline, alignment: .center)
    self.placeholderTitle.attributedText = NSAttributedString(string: Localization.placeholderTitle, attributes: titleAttributes)
    self.placeholderTitle.numberOfLines  = 0
    self.placeholderTitle.lineBreakMode  = .byWordWrapping
    self.placeholderView.addSubview(self.placeholderTitle)

    self.placeholderTitle.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.placeholderContent.attributedText = self.createPlaceholderContent()
    self.placeholderContent.numberOfLines  = 0
    self.placeholderView.addSubview(self.placeholderContent)

    self.placeholderContent.snp.makeConstraints { make in
      make.top.equalTo(self.placeholderTitle.snp.bottom).offset(Layout.Placeholder.verticalSpacing)
      make.left.bottom.right.equalToSuperview()
    }
  }

  private func createPlaceholderContent() -> NSAttributedString {
    let lineSpacing    = Layout.Placeholder.lineSpacing
    let textAttributes = Managers.theme.textAttributes(for: .body, fontType: .text, alignment: .center, lineSpacing: lineSpacing)
    let iconAttributes = Managers.theme.textAttributes(for: .body, fontType: .icon, alignment: .center, lineSpacing: lineSpacing)

    let starReplacement = TextReplacement("<star>", NSAttributedString(string: "\u{f006}", attributes: iconAttributes))

    return NSAttributedString(string: Localization.placeholderContent, attributes: textAttributes)
      .withReplacements([starReplacement])
  }
}
