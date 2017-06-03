//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

class BookmarksViewController: UIViewController {

  //MARK: - Properties

  let navigationBar = UINavigationBar()
  let closeButton   = UIBarButtonItem()

  let bookmarksTable            = UITableView()
  let bookmarksTablePlaceholder = UIView()
  let bookmarksDataSource       = BookmarksDataSource()

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
    self.bookmarksDataSource.delegate  = self
    self.bookmarksDataSource.bookmarks = BookmarksManager.instance.getBookmarks()
  }

  //MARK: - Actions

  @objc func closeButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }

}

//MARK: - CardPanelPresentable

extension BookmarksViewController: CardPanelPresentable {
  var contentView:       UIView { return self.view }
  var interactionTarget: UIView { return self.navigationBar }
}

//MARK: - UITableViewDelegate

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
      self.bookmarksTable.separatorStyle      = .none
      self.bookmarksTablePlaceholder.isHidden = false
    }
    else {
      self.navigationItem.setLeftBarButton(self.editButtonItem, animated: true)
      self.bookmarksTable.separatorStyle      = .singleLine
      self.bookmarksTablePlaceholder.isHidden = true
    }
  }
}
