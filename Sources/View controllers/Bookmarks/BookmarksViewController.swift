//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = BookmarksViewControllerConstants
fileprivate typealias Layout    = Constants.Layout

class BookmarksViewController: UIViewController {

  // MARK: - Properties

  let headerViewBlur = UIBlurEffect(style: .extraLight)

  lazy var headerView: UIVisualEffectView = {
    return UIVisualEffectView(effect: self.headerViewBlur)
  }()

  let chevronView = ChevronView()
  let cardTitle   = UILabel()
  let editButton  = UIButton()

  var bookmarksTableDataSource: BookmarksDataSource!
  let bookmarksTable = UITableView()

  let placeholderView        = UIView()
  let placeholderTopLabel    = UILabel()
  let placeholderBottomLabel = UILabel()

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initDataSource()
    self.initLayout()
    self.showPlaceholderIfEmpty()
  }

  private func initDataSource() {
    let bookmarks = Managers.bookmark.getAll()
    self.bookmarksTableDataSource = BookmarksDataSource(with: bookmarks, delegate: self)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.insetTableViewContentBelowHeaderView()
  }

  private func insetTableViewContentBelowHeaderView() {
    let currentInset = self.bookmarksTable.contentInset
    let headerHeight = self.headerView.bounds.height

    if currentInset.top < headerHeight {
      let newInset = UIEdgeInsets(top: headerHeight, left: currentInset.left, bottom: currentInset.bottom, right: currentInset.right)
      self.bookmarksTable.contentInset          = newInset
      self.bookmarksTable.scrollIndicatorInsets = newInset

      // scroll up to preserve current scroll position
      let currentOffset = self.bookmarksTable.contentOffset
      let newOffset     = CGPoint(x: currentOffset.x, y: currentOffset.y + currentInset.top - headerHeight)
      self.bookmarksTable.setContentOffset(newOffset, animated: false)
    }
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)

    if editing {
      self.editButton.setStyle(.linkBold)
      self.editButton.setTitle("Done", for: .normal)
      self.closeSwipeToDelte()
    }
    else {
      self.editButton.setStyle(.link)
      self.editButton.setTitle("Edit", for: .normal)
    }

    self.bookmarksTable.setEditing(editing, animated: true)
  }

  private func closeSwipeToDelte() {
    let hasSwipeToDeleteOpen = self.bookmarksTable.isEditing
    if hasSwipeToDeleteOpen {
      self.bookmarksTable.setEditing(false, animated: false)
    }
  }

  // MARK: - Actions

  @objc func editButtonPressed() {
    self.setEditing(!self.isEditing, animated: true)
  }

  // MARK: - Methods

  fileprivate func select(bookmark: Bookmark) {
    logger.info("didSelect: \(bookmark.name)")
    self.dismiss(animated: true, completion: nil)
  }

  fileprivate func showPlaceholderIfEmpty() {
    let bookmarks = self.bookmarksTableDataSource.bookmarks

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

// MARK: - CardPanelPresentable

extension BookmarksViewController: CardPanelPresentable {
  var contentView:       UIView { return self.view }
  var interactionTarget: UIView { return self.headerView }

  func dismissalTransitionWillBegin() {
    self.chevronView.setState(.flat, animated: true)
  }

  func dismissalTransitionDidEnd(_ completed: Bool) {
    if !completed {
      self.chevronView.setState(.down, animated: true)
    }
  }

}

// MARK: - UITableViewDelegate

extension BookmarksViewController: UITableViewDelegate {

  // MARK: Height

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return Layout.Cell.estimatedHeight
  }

  // MARK: - Selection

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let bookmark = self.bookmarksTableDataSource.bookmark(at: indexPath) {
      self.select(bookmark: bookmark)
    }
  }

}

// MARK: - BookmarksDataSourceDelegate

extension BookmarksViewController: BookmarksDataSourceDelegate {

  func dataSource(_ dataSource: BookmarksDataSource, didDelete bookmark: Bookmark) {
    Managers.bookmark.delete(bookmark) // we are 'ok' with gaps in ordering
    self.showPlaceholderIfEmpty()
  }

  func didReorderBookmarks(_ dataSource: BookmarksDataSource) {
    let bookmarks = self.recalculateBookmarkOrders(dataSource.bookmarks)
    Managers.bookmark.save(bookmarks)
  }

  private func recalculateBookmarkOrders(_ bookmarks: [Bookmark]) -> [Bookmark] {
    return bookmarks
      .enumerated()
      .map { (order, old) in
        return Bookmark(id: old.id, name: old.name, lines: old.lines, order: order + 1)
    }
  }

}
