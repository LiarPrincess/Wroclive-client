//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Constants    = BookmarksViewControllerConstants
private typealias Layout       = Constants.Layout
private typealias Localization = Localizable.Bookmarks

protocol BookmarksViewControllerDelegate: class {
  func bookmarksViewController(_ viewController: BookmarksViewController, didSelect bookmark: Bookmark)
  func bookmarksViewControllerDidClose(_ viewController: BookmarksViewController)
}

class BookmarksViewController: UIViewController {

  // MARK: - Properties

  weak var delegate: BookmarksViewControllerDelegate?

  lazy var headerView: UIVisualEffectView = {
    let headerViewBlur = UIBlurEffect(style: Managers.theme.colors.blurStyle)
    return UIVisualEffectView(effect: headerViewBlur)
  }()

  let cardTitle   = UILabel()
  let editButton  = UIButton()

  var bookmarksTableDataSource: BookmarksDataSource!
  let bookmarksTable = UITableView()

  let placeholderView    = UIView()
  let placeholderTitle   = UILabel()
  let placeholderContent = UILabel()

  // MARK: - Init

  convenience init(delegate: BookmarksViewControllerDelegate? = nil) {
    self.init(nibName: nil, bundle: nil, delegate: delegate)
  }

  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, delegate: BookmarksViewControllerDelegate? = nil) {
    self.delegate = delegate
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

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

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.delegate?.bookmarksViewControllerDidClose(self)
  }

  // MARK: - Editing

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
    let textAttributes = Managers.theme.textAttributes(for: .body, color: .tint)
    let title          = NSAttributedString(string: Localization.Edit.edit, attributes: textAttributes)
    self.editButton.setAttributedTitle(title, for: .normal)
  }

  func setEditButtonDone() {
    let textAttributes = Managers.theme.textAttributes(for: .bodyBold, color: .tint)
    let title          = NSAttributedString(string: Localization.Edit.done, attributes: textAttributes)
    self.editButton.setAttributedTitle(title, for: .normal)
  }

  private func closeSwipeToDelte() {
    let hasSwipeToDeleteOpen = self.bookmarksTable.isEditing
    if hasSwipeToDeleteOpen {
      self.bookmarksTable.setEditing(false, animated: false)
    }
  }

  // MARK: - Actions

  @objc
  func editButtonPressed() {
    self.setEditing(!self.isEditing, animated: true)
  }

  fileprivate func selectBookmark(_ bookmark: Bookmark) {
    self.delegate?.bookmarksViewController(self, didSelect: bookmark)
  }

  // MARK: - Private - Placeholder

  fileprivate func showPlaceholderIfEmpty() {
    let bookmarks = self.bookmarksTableDataSource.bookmarks

    let isPlaceholderVisible = bookmarks.isEmpty
    self.editButton.isHidden      = isPlaceholderVisible
    self.placeholderView.isHidden = !isPlaceholderVisible
  }
}

// MARK: - CardPanelPresentable

extension BookmarksViewController: CardPanelPresentable {
  var header: UIView  { return self.headerView.contentView }
  var height: CGFloat { return Constants.CardPanel.relativeHeight * screenHeight }
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
    let bookmark = self.bookmarksTableDataSource.bookmarkAt(indexPath.row)
    self.selectBookmark(bookmark)
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
