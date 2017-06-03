//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = BookmarksViewControllerConstants
fileprivate typealias Layout    = Constants.Layout

extension BookmarksViewController {

  func initLayout() {
    self.view.backgroundColor = UIColor.white
    self.initNavigationBar()
    self.initBookmarksTable()
    self.initBookmarksTablePlaceholder()
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
    self.bookmarksTable.separatorInset = .zero
    self.bookmarksTable.dataSource     = self.bookmarksDataSource
    self.bookmarksTable.delegate       = self
    self.view.insertSubview(self.bookmarksTable, belowSubview: self.navigationBar)

    self.bookmarksTable.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBar.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
  }

  fileprivate func initBookmarksTablePlaceholder() {
    // we cant use 'self.bookmarksTable' as this would result in incorrect left <-> right constraints
    self.view.addSubview(self.bookmarksTablePlaceholder)

    self.bookmarksTablePlaceholder.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBar.snp.bottom)
      make.left.equalToSuperview().offset(Layout.Placeholder.leftOffset)
      make.right.equalToSuperview().offset(-Layout.Placeholder.rightOffset)
      make.bottom.equalToSuperview()
    }

    let topLabel = createPlaceholderLabel()
    topLabel.text = "You have not saved any bookmarks"
    topLabel.font = FontManager.instance.bookmarkPlaceholderTitle
    self.bookmarksTablePlaceholder.addSubview(topLabel)

    topLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Placeholder.TopLabel.topOffset)
      make.left.right.equalToSuperview()
    }

    let bottomLabel = createPlaceholderLabel()
    bottomLabel.text = "To add bookmark press 'Save' when searching (X) for lines."
    bottomLabel.font = FontManager.instance.bookmarkPlaceholderContent
    self.bookmarksTablePlaceholder.addSubview(bottomLabel)

    bottomLabel.snp.makeConstraints { make in
      make.top.equalTo(topLabel.snp.bottom).offset(Layout.Placeholder.BottomLabel.topOffset)
      make.left.right.equalToSuperview()
    }
  }

  fileprivate func createPlaceholderLabel() -> UILabel {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }

}
