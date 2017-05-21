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
  let editButton = UIBarButtonItem()

  let bookmarksTable = UITableView()
  let bookmarksDataSource = BookmarksDataSource()

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.bookmarksDataSource.bookmarks = BookmarksModule.sharedInstance.getAll()

    self.view.backgroundColor = UIColor.white
    self.initNavigationBar()
    self.initBookmarksTable()
  }

  //MARK: - Actions

  @objc fileprivate func editButtonPressed() {
    log.info("editButtonPressed")
  }

  @objc fileprivate func closeButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }

}

//MARK: - TableViewDelegate

extension BookmarksViewController: UITableViewDelegate {

  //MARK: - Display

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? BookmarkCell else {
      fatalError("Invalid cell type passed to BookmarksViewController.UITableViewDelegate")
    }

    cell.tramLines.isHidden = cell.tramLines.text?.isEmpty ?? true
    cell.tramLines.textColor = self.view.tintColor

    cell.busLines.isHidden = cell.busLines.text?.isEmpty ?? true
    cell.busLines.textColor = self.view.tintColor
  }

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

  fileprivate func initNavigationBar() {
    self.view.addSubview(self.navigationBar)

    navigationBar.snp.makeConstraints { make in
      make.left.right.top.equalToSuperview()
    }

    let navigationItem = UINavigationItem(title: "Bookmarks")
    navigationBar.pushItem(navigationItem, animated: false)

    self.editButton.style = .plain
    self.editButton.title = "Edit"
    self.editButton.target = self
    self.editButton.action = #selector(editButtonPressed)
    navigationItem.leftBarButtonItem = self.editButton

    self.closeButton.style = .plain
    self.closeButton.title = "Close"
    self.closeButton.target = self
    self.closeButton.action = #selector(closeButtonPressed)
    navigationItem.rightBarButtonItem = self.closeButton
  }

  fileprivate func initBookmarksTable() {
    self.bookmarksTable.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.identifier)
    self.bookmarksTable.dataSource = self.bookmarksDataSource
    self.bookmarksTable.delegate = self
    self.view.addSubview(self.bookmarksTable)

    self.bookmarksTable.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBar.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
  }

}
