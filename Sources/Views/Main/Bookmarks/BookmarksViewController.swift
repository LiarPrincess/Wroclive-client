//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import SnapKit

class BookmarksViewController: UIViewController {

  //MARK: - Properties

  let navigationBar = UINavigationBar()
  let closeButton = UIBarButtonItem()

  let bookmarksTable = UITableView()
  let bookmarksDataSource = BookmarksDataSource()

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    self.bookmarksTable.setEditing(editing, animated: true)
  }

  //MARK: - Actions

  @objc fileprivate func editButtonPressed() {
    self.setEditing(true, animated: true)
  }

  @objc fileprivate func editCommitButtonPressed() {
    self.setEditing(false, animated: true)
  }

  @objc fileprivate func closeButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }

}

//MARK: - CardPanelPresentable

extension BookmarksViewController: CardPanelPresentable {
  var contentView: UIView { return self.view }
  var interactionTarget: UIView { return self.navigationBar }
}

//MARK: - TableViewDelegate

extension BookmarksViewController: UITableViewDelegate {

  //MARK: - Height

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.rowHeight
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
    self.bookmarksTable.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.identifier)
    self.bookmarksTable.separatorInset = .zero
    self.bookmarksTable.dataSource = self.bookmarksDataSource
    self.bookmarksTable.delegate = self
    self.view.addSubview(self.bookmarksTable)

    self.bookmarksTable.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBar.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
  }

}
