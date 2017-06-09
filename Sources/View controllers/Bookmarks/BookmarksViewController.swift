//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = BookmarksViewControllerConstants
fileprivate typealias Layout    = Constants.Layout

class BookmarksViewController: UIViewController {

  //MARK: - Properties

  let headerViewBlur = UIBlurEffect(style: .extraLight)

  lazy var headerView: UIVisualEffectView =  {
    return UIVisualEffectView(effect: self.headerViewBlur)
  }()

  let cardTitle  = UILabel()
  let editButton = UIButton()

  var bookmarksDataSource: BookmarksDataSource!
  let bookmarksTable = UITableView()

  let placeholderView        = UIView()
  let placeholderTopLabel    = UILabel()
  let placeholderBottomLabel = UILabel()

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initDataSource()
    self.initLayout()
    self.updateLayoutAfterRowCountChanged()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.positionTableViewBelowHeaderView()
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)

    if editing {
      self.editButton.setStyle(.linkBold)
      self.editButton.setTitle("Done", for: .normal)

      let hasSwipeToDeleteOpen = self.bookmarksTable.isEditing
      if hasSwipeToDeleteOpen {
        self.bookmarksTable.setEditing(false, animated: false)
      }
    }
    else {
      self.editButton.setStyle(.link)
      self.editButton.setTitle("Edit", for: .normal)
    }

    self.bookmarksTable.setEditing(editing, animated: true)
  }

  private func initDataSource() {
    let bookmarks            = BookmarksManager.instance.getAll()
    self.bookmarksDataSource = BookmarksDataSource(with: bookmarks, delegate: self)
  }

  //MARK: - Actions

  @objc func editButtonPressed() {
    self.setEditing(!self.isEditing, animated: true)
  }

  //MARK: - Methods

  fileprivate func select(bookmark: Bookmark) {
    logger.info("didSelect: \(bookmark.name)")
    self.dismiss(animated: true, completion: nil)
  }

  fileprivate func updateLayoutAfterRowCountChanged() {
    let bookmarks = self.bookmarksDataSource.bookmarks

    if bookmarks.count == 0 {
      self.bookmarksTable.separatorStyle = .none
      self.editButton.isHidden           = true
      self.placeholderView.isHidden      = false
    }
    else {
      self.bookmarksTable.separatorStyle = .singleLine
      self.editButton.isHidden           = false
      self.placeholderView.isHidden      = true
    }
  }

}

//MARK: - CardPanelPresentable

extension BookmarksViewController: CardPanelPresentable {
  var contentView:       UIView { return self.view }
  var interactionTarget: UIView { return self.headerView }
}

//MARK: - UITableViewDelegate

extension BookmarksViewController: UITableViewDelegate {

  //MARK: Height

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return Layout.Cell.estimatedHeight
  }

  //MARK: - Selection

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let bookmark = self.bookmarksDataSource.bookmark(at: indexPath) {
      self.select(bookmark: bookmark)
    }
  }

}

//MARK: - BookmarksDataSourceDelegate

extension BookmarksViewController: BookmarksDataSourceDelegate {

  func didUpdateBookmarkCount(_ dataSource: BookmarksDataSource) {
    self.updateLayoutAfterRowCountChanged()
    self.saveBookmarks()
  }

  func didReorderBookmarks(_ dataSource: BookmarksDataSource) {
    self.saveBookmarks()
  }

  private func saveBookmarks() {
    let bookmarks = self.bookmarksDataSource.bookmarks
    BookmarksManager.instance.save(bookmarks: bookmarks)
  }

}
