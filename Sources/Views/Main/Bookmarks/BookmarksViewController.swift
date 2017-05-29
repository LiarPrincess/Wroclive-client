//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import SnapKit

class BookmarksViewController: UIViewController {

  //MARK: - Properties

  let navigationBar = UINavigationBar()
  let closeButton   = UIBarButtonItem()

  let bookmarksTable      = UITableView()
  let bookmarksDataSource = BookmarksDataSource()

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initDataSource()
    self.initLayout()
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    self.bookmarksTable.setEditing(editing, animated: true)
  }

  private func initDataSource() {
    self.bookmarksDataSource.delegate = self
    self.bookmarksDataSource.bookmarks = BookmarksManager.instance.getBookmarks()
  }

  //MARK: - Actions

  @objc fileprivate func closeButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }

}

//MARK: - CardPanelPresentable

extension BookmarksViewController: CardPanelPresentable {
  var contentView:       UIView { return self.view }
  var interactionTarget: UIView { return self.navigationBar }
}

//MARK: - TableViewDelegate

extension BookmarksViewController: UITableViewDelegate {

  //MARK: Height

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.rowHeight
  }

}

//MARK: - BookmarksDataSourceDelegate

extension BookmarksViewController: BookmarksDataSourceDelegate {
  func bookmarksDataSource(_ dataSource: BookmarksDataSource, didChangeRowCount rowCount: Int) {
    if rowCount == 0 {
      self.navigationItem.setLeftBarButton(nil, animated: true)
      self.bookmarksTable.separatorStyle = .none
      self.bookmarksTable.backgroundView?.isHidden = false
    }
    else {
      self.navigationItem.setLeftBarButton(self.editButtonItem, animated: true)
      self.bookmarksTable.separatorStyle = .singleLine
      self.bookmarksTable.backgroundView?.isHidden = true
    }
  }
}

//MARK: - UI Init

extension BookmarksViewController {

  fileprivate func initLayout() {
    self.view.backgroundColor = UIColor.white
    self.initNavigationBar()
    self.initBookmarksTable()
  }

  private func initNavigationBar() {
    self.view.addSubview(self.navigationBar)

    navigationBar.snp.makeConstraints { make in
      make.left.right.top.equalToSuperview()
    }

    self.navigationItem.title = "Bookmarks"
    self.navigationBar.pushItem(navigationItem, animated: false)

    self.closeButton.style = .plain
    self.closeButton.title = "Close"
    self.closeButton.target = self
    self.closeButton.action = #selector(closeButtonPressed)

    self.navigationItem.setLeftBarButton(self.editButtonItem, animated: false)
    self.navigationItem.setRightBarButton(self.closeButton, animated: false)
  }

  private func initBookmarksTable() {
    self.bookmarksTable.register(BookmarkCell.self)
    self.bookmarksTable.separatorInset = .zero
    self.bookmarksTable.backgroundView = self.createBookmarksTablePlaceholder()
    self.bookmarksTable.dataSource = self.bookmarksDataSource
    self.bookmarksTable.delegate = self
    self.view.addSubview(self.bookmarksTable)

    self.bookmarksTable.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBar.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
  }

  private func createBookmarksTablePlaceholder() -> UIView {
    func createPlaceholderLabel() -> UILabel {
      let label = UILabel()
      label.textAlignment = .center
      label.numberOfLines = 0
      return label
    }

    let placeholder = UIView()

    let topLabel = createPlaceholderLabel()
    topLabel.text = "You have not saved\nany bookmarks"
    topLabel.font = FontManager.instance.bookmarkPlaceholderTitle
    placeholder.addSubview(topLabel)

    topLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(30.0) // a little bith higher?
      make.left.right.equalToSuperview()
    }

    let bottomLabel = createPlaceholderLabel()
    bottomLabel.text = "To add bookmark press\n'Save' when searching (X)\nfor lines."
    bottomLabel.font = FontManager.instance.bookmarkPlaceholderContent
    placeholder.addSubview(bottomLabel)

    bottomLabel.snp.makeConstraints { make in
      make.top.equalTo(topLabel.snp.bottom).offset(8.0)
      make.left.right.equalToSuperview()
    }

    return placeholder
  }

}
