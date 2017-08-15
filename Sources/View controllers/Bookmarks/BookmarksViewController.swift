//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants    = BookmarksViewControllerConstants
fileprivate typealias Layout       = Constants.Layout
fileprivate typealias Localization = Constants.Localization

class BookmarksViewController: UIViewController {

  // MARK: - Properties

  weak var delegate: BookmarksViewControllerDelegate?

  let headerViewBlur = UIBlurEffect(style: Theme.current.colorScheme.blurStyle)

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
    let bookmarks = Managers.bookmarks.getAll()
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
      self.setEditButtonDone()
      self.closeSwipeToDelte()
    }
    else { self.setEditButtonEdit() }

    self.bookmarksTable.setEditing(editing, animated: true)
  }

  func setEditButtonEdit() {
    let textAttributes = Theme.current.textAttributes(for: .body, color: .tint)
    let title          = NSAttributedString(string: Localization.editEdit, attributes: textAttributes)
    self.editButton.setAttributedTitle(title, for: .normal)
  }

  func setEditButtonDone() {
    let textAttributes = Theme.current.textAttributes(for: .bodyBold, color: .tint)
    let title          = NSAttributedString(string: Localization.editDone, attributes: textAttributes)
    self.editButton.setAttributedTitle(title, for: .normal)
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

  fileprivate func selectBookmark(_ bookmark: Bookmark) {
    self.delegate?.bookmarksViewController(self, didSelect: bookmark)
    self.dismiss(animated: true, completion: nil)
  }

  // MARK: - Private - Placeholder

  fileprivate func showPlaceholderIfEmpty() {
    let bookmarks = self.bookmarksTableDataSource.bookmarks

    if bookmarks.count == 0 {
      Theme.current.applyTableViewSeparatorStyle(self.bookmarksTable, separatorStyle: .transparent)
      self.editButton.isHidden      = true
      self.placeholderView.isHidden = false
    }
    else {
      Theme.current.applyTableViewSeparatorStyle(self.bookmarksTable, separatorStyle: .accent)
      self.editButton.isHidden      = false
      self.placeholderView.isHidden = true
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
      self.selectBookmark(bookmark)
    }
  }

}

// MARK: - BookmarksDataSourceDelegate

extension BookmarksViewController: BookmarksDataSourceDelegate {

  func dataSource(_ dataSource: BookmarksDataSource, didDelete bookmark: Bookmark) {
    self.saveBookmarks()
    self.showPlaceholderIfEmpty()
  }

  func didReorderBookmarks(_ dataSource: BookmarksDataSource) {
    self.saveBookmarks()
  }

  private func saveBookmarks() {
    let bookmarks = self.bookmarksTableDataSource.bookmarks
    Managers.bookmarks.save(bookmarks)
  }

}
