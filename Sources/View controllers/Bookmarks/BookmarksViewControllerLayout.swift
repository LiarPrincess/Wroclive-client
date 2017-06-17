//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = BookmarksViewControllerConstants
fileprivate typealias Layout    = Constants.Layout

//MARK: - Layout

extension BookmarksViewController {

  func initLayout() {
    self.view.setStyle(.cardPanel)

    self.initHeader()
    self.initBookmarksTable()
    self.initBookmarksTablePlaceholder()
  }

  //MARK: - Private
  
  private func initHeader() {
    self.headerView.setStyle(.cardPanelHeader)
    self.view.addSubview(self.headerView)

    self.headerView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.chevronView.state = .down
    self.chevronView.color = Theme.current.colorScheme.backgroundContrast
    self.chevronView.animationDuration = Constants.Animations.chevronDismisRelativeDuration
    self.view.addSubview(chevronView)

    self.chevronView.snp.makeConstraints { make in
      let chevronViewSize = ChevronView.nominalSize

      make.top.equalToSuperview().offset(Layout.Header.chevronTopOffset)
      make.centerX.equalToSuperview()
      make.width.equalTo(chevronViewSize.width)
      make.height.equalTo(chevronViewSize.height)
    }

    self.cardTitle.setStyle(.headline)
    self.cardTitle.text          = "Bookmarks"
    self.cardTitle.numberOfLines = 0
    self.cardTitle.lineBreakMode = .byWordWrapping
    self.headerView.addSubview(self.cardTitle)

    self.cardTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Header.topPadding)
      make.bottom.equalToSuperview().offset(-Layout.Header.bottomPadding)
      make.left.equalToSuperview().offset(Layout.leftOffset)
    }

    self.editButton.setStyle(.link)
    self.editButton.setTitle("Edit", for: .normal)
    self.editButton.setContentHuggingPriority(251.0, for: .horizontal)
    self.editButton.contentEdgeInsets = Layout.Header.EditButton.contentInsets
    self.editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
    self.headerView.addSubview(self.editButton)

//self.cardTitle.backgroundColor = UIColor.green
//self.editButton.backgroundColor = UIColor.blue

    self.editButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.cardTitle.snp.lastBaseline)
      make.left.equalTo(self.cardTitle.snp.right).inset(-Layout.Header.horizontalSpacing)
      make.right.equalToSuperview()
    }
  }

  private func initBookmarksTable() {
    self.bookmarksTable.register(BookmarkCell.self)
    self.bookmarksTable.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    self.bookmarksTable.dataSource     = self.bookmarksTableDataSource
    self.bookmarksTable.delegate       = self
    self.view.insertSubview(self.bookmarksTable, belowSubview: self.headerView)

    self.bookmarksTable.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func initBookmarksTablePlaceholder() {
    // we cant use 'self.bookmarksTable.backgroundView' as this would result in incorrect left <-> right constraints
    self.view.addSubview(self.placeholderView)

    self.placeholderView.snp.makeConstraints { make in
      make.top.equalTo(self.headerView.snp.bottom)
      make.left.equalToSuperview().offset(Layout.Placeholder.leftOffset)
      make.right.equalToSuperview().offset(-Layout.Placeholder.rightOffset)
      make.bottom.equalToSuperview()
    }

    self.placeholderTopLabel.setStyle(.subheadline)
    self.placeholderTopLabel.numberOfLines = 0
    self.placeholderTopLabel.textAlignment = .center
    self.placeholderTopLabel.lineBreakMode = .byWordWrapping
    self.placeholderTopLabel.text          = "You have not saved any bookmarks"
    self.placeholderView.addSubview(self.placeholderTopLabel)

    self.placeholderTopLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Placeholder.TopLabel.topOffset)
      make.left.right.equalToSuperview()
    }

    self.placeholderBottomLabel.setStyle(.body)
    self.placeholderBottomLabel.numberOfLines = 0
    self.placeholderBottomLabel.textAlignment = .center
    self.placeholderBottomLabel.lineBreakMode = .byWordWrapping
    self.placeholderBottomLabel.text          = "To add bookmark press 'Save' when selectings lines."
    self.placeholderView.addSubview(self.placeholderBottomLabel)

    self.placeholderBottomLabel.snp.makeConstraints { make in
      make.top.equalTo(self.placeholderTopLabel.snp.bottom).offset(Layout.Placeholder.BottomLabel.topOffset)
      make.left.right.equalToSuperview()
    }
  }

}
