
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
    self.initNavigationBar()
    self.initBookmarksTable()
    self.initBookmarksTablePlaceholder()
    self.applyTheme()
  }

  fileprivate func initNavigationBar() {
    self.view.addSubview(self.navigationBar)

    navigationBar.snp.makeConstraints { make in
      make.left.right.top.equalToSuperview()
    }

    self.navigationItem.title = "Bookmarks"
    self.navigationBar.pushItem(navigationItem, animated: false)

    self.closeButton.style  = .plain
    self.closeButton.title  = "Close"
    self.closeButton.target = self
    self.closeButton.action = #selector(closeButtonPressed)

    self.navigationItem.setLeftBarButton(self.editButtonItem, animated: false)
    self.navigationItem.setRightBarButton(self.closeButton, animated: false)
  }

  fileprivate func initBookmarksTable() {
    self.bookmarksTable.register(BookmarkCell.self)
    self.bookmarksTable.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    self.bookmarksTable.dataSource     = self.bookmarksDataSource
    self.bookmarksTable.delegate       = self
    self.view.insertSubview(self.bookmarksTable, belowSubview: self.navigationBar)

    self.bookmarksTable.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBar.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
  }

  fileprivate func initBookmarksTablePlaceholder() {
    // we cant use 'self.bookmarksTable.backgroundView' as this would result in incorrect left <-> right constraints
    self.view.addSubview(self.placeholderView)

    self.placeholderView.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBar.snp.bottom)
      make.left.equalToSuperview().offset(Layout.Placeholder.leftOffset)
      make.right.equalToSuperview().offset(-Layout.Placeholder.rightOffset)
      make.bottom.equalToSuperview()
    }

    self.placeholderTopLabel.numberOfLines = 0
    self.placeholderTopLabel.textAlignment = .center
    self.placeholderTopLabel.text          = "You have not saved any bookmarks"
    self.placeholderView.addSubview(self.placeholderTopLabel)

    self.placeholderTopLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Placeholder.TopLabel.topOffset)
      make.left.right.equalToSuperview()
    }

    self.placeholderBottomLabel.numberOfLines = 0
    self.placeholderBottomLabel.textAlignment = .center
    self.placeholderBottomLabel.text          = "To add bookmark press 'Save' when searching (X) for lines."
    self.placeholderView.addSubview(self.placeholderBottomLabel)

    self.placeholderBottomLabel.snp.makeConstraints { make in
      make.top.equalTo(self.placeholderTopLabel.snp.bottom).offset(Layout.Placeholder.BottomLabel.topOffset)
      make.left.right.equalToSuperview()
    }
  }

}

//MARK: - Theme 

extension BookmarksViewController {

  func applyTheme() {
    self.view.backgroundColor = UIColor.white
    self.placeholderTopLabel.font    = Theme.current.font.headline
    self.placeholderBottomLabel.font = Theme.current.font.body
  }

}
